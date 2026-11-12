import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  Logger,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as argon2 from 'argon2';
import { v4 as uuidv4 } from 'uuid';
import { PrismaService } from '../../prisma/prisma.service';
import { RedisService } from '../../redis/redis.service';
import { RegisterDto, LoginDto, RefreshTokenDto, AuthResponseDto } from './auth.dto';
import { ErrorCode } from '../../common/dto/error.dto';

const MIGRATION_WHITELIST = ['quicktip.viewed', 'question.viewed', 'topic.explored'];

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async register(dto: RegisterDto): Promise<AuthResponseDto> {
    const existing = await this.prisma.user.findFirst({
      where: { email: dto.email.toLowerCase() },
    });

    if (existing) {
      throw new ConflictException({
        code: ErrorCode.VALIDATION_FAILED,
        message: 'A user with this email address already exists',
      });
    }

    const passwordHash = await argon2.hash(dto.password);

    // Create User + Profile in transaction
    const user = await this.prisma.$transaction(async (tx) => {
      const newUser = await tx.user.create({
        data: {
          email: dto.email.toLowerCase(),
          passwordHash,
          role: 'user',
          status: 'active',
          profile: {
            create: {
              name: dto.name,
              contactEmail: dto.email.toLowerCase(),
            },
          },
        },
        include: { profile: true },
      });

      return newUser;
    });

    // Handle guest migration if guestRef provided
    if (dto.guestRef) {
      await this.migrateGuestData(dto.guestRef, user.id);
    }

    return this.generateAuthResponse(user.id, user.email!, user.profile?.name || dto.name, user.role);
  }

  async login(dto: LoginDto): Promise<AuthResponseDto> {
    const user = await this.prisma.user.findFirst({
      where: { email: dto.email.toLowerCase() },
      include: { profile: true },
    });

    if (!user || !user.passwordHash) {
      throw new UnauthorizedException({
        code: ErrorCode.UNAUTHORIZED,
        message: 'Invalid email or password',
      });
    }

    const validPassword = await argon2.verify(user.passwordHash, dto.password);
    if (!validPassword) {
      throw new UnauthorizedException({
        code: ErrorCode.UNAUTHORIZED,
        message: 'Invalid email or password',
      });
    }

    if (dto.guestRef) {
      await this.migrateGuestData(dto.guestRef, user.id);
    }

    return this.generateAuthResponse(user.id, user.email!, user.profile?.name || 'User', user.role);
  }

  async refresh(dto: RefreshTokenDto): Promise<AuthResponseDto> {
    const session = await this.prisma.refreshSession.findFirst({
      where: {
        refreshTokenHash: dto.refreshToken,
        revokedAt: null,
        expiresAt: { gt: new Date() },
      },
      include: { user: { include: { profile: true } } },
    });

    if (!session || !session.user) {
      throw new UnauthorizedException({
        code: ErrorCode.SESSION_EXPIRED,
        message: 'Refresh token is invalid or expired',
      });
    }

    // Revoke old session (token rotation)
    await this.prisma.refreshSession.update({
      where: { id: session.id },
      data: { revokedAt: new Date() },
    });

    const user = session.user;
    return this.generateAuthResponse(user.id, user.email!, user.profile?.name || 'User', user.role);
  }

  async logout(userId: string): Promise<{ success: boolean }> {
    await this.prisma.refreshSession.updateMany({
      where: { userId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
    return { success: true };
  }

  async getSession(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: { profile: true },
    });

    if (!user) {
      throw new UnauthorizedException({
        code: ErrorCode.NOT_FOUND,
        message: 'User session not found',
      });
    }

    return {
      id: user.id,
      email: user.email,
      name: user.profile?.name,
      role: user.role,
      status: user.status,
    };
  }

  private async generateAuthResponse(
    userId: string,
    email: string,
    name: string,
    role: string,
  ): Promise<AuthResponseDto> {
    const payload = { sub: userId, email, role };
    const secret = this.configService.get<string>('JWT_SECRET', 'dev-jwt-secret-replace-in-production-min-32-chars');
    const accessTtl = this.configService.get<string>('JWT_ACCESS_TTL', '900s');

    const accessToken = await this.jwtService.signAsync(payload, {
      secret,
      expiresIn: accessTtl,
    });

    const refreshToken = uuidv4();
    const refreshExpiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000); // 30 days

    await this.prisma.refreshSession.create({
      data: {
        userId,
        refreshTokenHash: refreshToken,
        expiresAt: refreshExpiresAt,
      },
    });

    return {
      accessToken,
      refreshToken,
      user: {
        id: userId,
        email,
        name,
        role,
      },
    };
  }

  /**
   * Flow 03: Guest Conversion & Migration
   * Migrates whitelisted guest events from Redis to Postgres in a single transaction.
   * Enforces idempotency via ActivityEvent.sourceEventId.
   * ONLY deletes Redis keys after transaction successfully commits.
   */
  async migrateGuestData(guestRef: string, userId: string): Promise<void> {
    try {
      const eventsKey = `guest:events:${guestRef}`;
      const rawEvents = await this.redis.lrange(eventsKey, 0, -1);

      const parsedEvents = rawEvents
        .map((r) => {
          try {
            return JSON.parse(r);
          } catch {
            return null;
          }
        })
        .filter((e) => e && MIGRATION_WHITELIST.includes(e.type));

      await this.prisma.$transaction(async (tx) => {
        let count = 0;
        for (const ev of parsedEvents) {
          await tx.activityEvent.upsert({
            where: { sourceEventId: ev.sourceEventId || `${guestRef}_${ev.type}_${count}` },
            update: {},
            create: {
              userId,
              type: ev.type,
              refId: ev.refId || null,
              payload: ev.payload || {},
              sourceEventId: ev.sourceEventId || `${guestRef}_${ev.type}_${count}`,
            },
          });
          count++;
        }

        await tx.guestMigration.create({
          data: {
            guestRef,
            userId,
            eventsMigrated: count,
          },
        });
      });

      // ONLY delete Redis keys AFTER commit succeeds
      await this.redis.del(
        `guest:session:${guestRef}`,
        `guest:quota:quicktip:${guestRef}`,
        `guest:events:${guestRef}`,
        `guest:questions:${guestRef}`,
      );
      this.logger.log(`Successfully migrated guest ${guestRef} to user ${userId}`);
    } catch (err: any) {
      this.logger.error(`Guest migration failed for ${guestRef}: ${err.message}. Retaining Redis keys.`);
      // Per spec: do NOT delete Redis keys if migration fails
    }
  }
}

