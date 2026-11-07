import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  ConflictException,
} from '@nestjs/common';
import { Observable, of } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Request } from 'express';
import { RedisService } from '../../redis/redis.service';
import { ErrorCode } from '../dto/error.dto';

@Injectable()
export class IdempotencyInterceptor implements NestInterceptor {
  constructor(private readonly redis: RedisService) {}

  async intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Promise<Observable<any>> {
    const request = context.switchToHttp().getRequest<Request>();
    const method = request.method.toUpperCase();

    // Only apply to mutating requests
    if (!['POST', 'PUT', 'PATCH', 'DELETE'].includes(method)) {
      return next.handle();
    }

    const idempotencyKey =
      (request.headers['idempotency-key'] as string) ||
      (request.headers['x-idempotency-key'] as string);

    if (!idempotencyKey) {
      return next.handle();
    }

    const scope = (request.user as any)?.id || 'anon';
    const redisKey = `idem:${scope}:${idempotencyKey}`;
    const lockKey = `lock:idem:${scope}:${idempotencyKey}`;

    // 1. Check for cached response
    try {
      const cached = await this.redis.get(redisKey);
      if (cached) {
        const parsed = JSON.parse(cached);
        return of(parsed);
      }
    } catch {
      // In case Redis is down or parsing fails, continue
    }

    // 2. Short-lived lock to prevent simultaneous duplicate requests
    try {
      const acquired = await this.redis.client.set(lockKey, 'locked', 'EX', 10, 'NX');
      if (!acquired) {
        throw new ConflictException({
          code: ErrorCode.IDEMPOTENCY_CONFLICT,
          message: 'Concurrent request with the same idempotency key is processing',
        });
      }
    } catch (e) {
      if (e instanceof ConflictException) throw e;
    }

    return next.handle().pipe(
      tap(async (response) => {
        try {
          // Cache response for 1 hour (3600 seconds)
          await this.redis.client.setex(redisKey, 3600, JSON.stringify(response));
          await this.redis.del(lockKey);
        } catch {
          // Ignore cache save failure
        }
      }),
    );
  }
}

