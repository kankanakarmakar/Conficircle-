import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ENTITLEMENT_KEY } from '../decorators/entitlement.decorator';
import { PrismaService } from '../../prisma/prisma.service';
import { ErrorCode } from '../dto/error.dto';

@Injectable()
export class EntitlementGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const requiredFeature = this.reflector.getAllAndOverride<string>(
      ENTITLEMENT_KEY,
      [context.getHandler(), context.getClass()],
    );

    if (!requiredFeature) {
      return true;
    }

    // Check database feature flag
    try {
      const flag = await this.prisma.featureFlag.findUnique({
        where: { key: requiredFeature },
      });

      if (flag && !flag.enabled) {
        throw new ForbiddenException({
          code: ErrorCode.FORBIDDEN,
          message: `The feature '${requiredFeature}' is currently disabled`,
        });
      }
    } catch (e) {
      if (e instanceof ForbiddenException) throw e;
      // If table doesn't exist yet or connection fails during early init, allow if not explicitly blocked
    }

    return true;
  }
}

