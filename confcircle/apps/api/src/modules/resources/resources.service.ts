import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';
import { PrismaService } from '../../prisma/prisma.service';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { ErrorCode } from '../../common/dto/error.dto';

@Injectable()
export class ResourcesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly configService: ConfigService,
  ) {}

  async getResources(q?: string, category?: string, user?: AuthenticatedUser) {
    const isRegistered = user && !user.isGuest;

    const where: any = {
      status: 'published',
      accessRule: isRegistered ? undefined : 'public',
    };

    if (category) {
      where.category = category;
    }

    if (q) {
      where.OR = [
        { title: { contains: q, mode: 'insensitive' } },
        { tags: { has: q } },
      ];
    }

    const resources = await this.prisma.resource.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        title: true,
        category: true,
        tags: true,
        accessRule: true,
        createdAt: true,
      },
    });

    return resources;
  }

  async getResource(id: string, user?: AuthenticatedUser) {
    const resource = await this.prisma.resource.findUnique({
      where: { id },
    });

    if (!resource || resource.status !== 'published') {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Resource not found',
      });
    }

    if (resource.accessRule === 'registered_only' && (!user || user.isGuest)) {
      throw new ForbiddenException({
        code: ErrorCode.ACCOUNT_REQUIRED,
        message: 'This resource requires a registered account',
      });
    }

    return resource;
  }

  async getDownloadUrl(id: string, user?: AuthenticatedUser) {
    const resource = await this.getResource(id, user);

    const ttlSeconds = this.configService.get<number>('DOWNLOAD_URL_TTL_SECONDS', 300);
    const expiresAt = Math.floor(Date.now() / 1000) + ttlSeconds;
    const secret = this.configService.get<string>('DOWNLOAD_URL_SIGN_SECRET', 'default-download-sign-secret');
    const userId = user?.id || 'guest';

    const payload = `${id}:${userId}:${expiresAt}`;
    const signature = crypto.createHmac('sha256', secret).update(payload).digest('hex');

    const downloadUrl = `https://cdn.confcircle.internal/files/${resource.storageKey}?exp=${expiresAt}&uid=${userId}&sig=${signature}`;

    // Record ResourceEvent
    await this.prisma.resourceEvent.create({
      data: {
        resourceId: id,
        userId: user && !user.isGuest ? user.id : null,
        type: 'download',
      },
    });

    return {
      downloadUrl,
      expiresAt: expiresAt * 1000,
    };
  }
}

