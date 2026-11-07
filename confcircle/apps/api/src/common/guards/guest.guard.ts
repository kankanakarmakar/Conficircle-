import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { RedisService } from '../../redis/redis.service';
import { ErrorCode } from '../dto/error.dto';

@Injectable()
export class GuestGuard implements CanActivate {
  constructor(private readonly redis: RedisService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const guestRef = request.headers['x-guest-ref'] as string;

    if (!guestRef) {
      throw new UnauthorizedException({
        code: ErrorCode.ACCOUNT_REQUIRED,
        message: 'Guest reference header (X-Guest-Ref) is required',
      });
    }

    const sessionExists = await this.redis.exists(`guest:session:${guestRef}`);
    if (!sessionExists) {
      throw new UnauthorizedException({
        code: ErrorCode.SESSION_EXPIRED,
        message: 'Guest session has expired. Please refresh your session.',
      });
    }

    request.user = {
      id: guestRef,
      guestRef,
      role: 'guest',
      isGuest: true,
    };

    return true;
  }
}

