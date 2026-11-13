import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';
import { ErrorCode } from '../dto/error.dto';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers.authorization;
    const guestRef = request.headers['x-guest-ref'];

    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      try {
        const secret = this.configService.get<string>('JWT_SECRET', 'dev-jwt-secret-replace-in-production-min-32-chars');
        const payload = await this.jwtService.verifyAsync(token, { secret });
        request.user = {
          id: payload.sub,
          email: payload.email,
          role: payload.role || 'user',
          isGuest: false,
        };
        return true;
      } catch (err) {
        if (!isPublic) {
          throw new UnauthorizedException({
            code: ErrorCode.UNAUTHORIZED,
            message: 'Invalid or expired access token',
          });
        }
      }
    }

    // If guest reference provided
    if (guestRef) {
      request.user = {
        id: guestRef,
        guestRef,
        role: 'guest',
        isGuest: true,
      };
      if (isPublic) return true;
    }

    if (isPublic) {
      return true;
    }

    throw new UnauthorizedException({
      code: ErrorCode.ACCOUNT_REQUIRED,
      message: 'This feature requires a registered account',
    });
  }
}

