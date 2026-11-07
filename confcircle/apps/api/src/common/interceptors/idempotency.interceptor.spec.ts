import { ExecutionContext, CallHandler } from '@nestjs/common';
import { of } from 'rxjs';
import { IdempotencyInterceptor } from './idempotency.interceptor';
import { RedisService } from '../../redis/redis.service';

describe('IdempotencyInterceptor', () => {
  let interceptor: IdempotencyInterceptor;
  let redisService: any;

  beforeEach(() => {
    redisService = {
      get: jest.fn(),
      del: jest.fn(),
      client: {
        set: jest.fn().mockResolvedValue('OK'),
        setex: jest.fn().mockResolvedValue('OK'),
      },
    };
    interceptor = new IdempotencyInterceptor(redisService);
  });

  it('should replay cached response on duplicate request without calling next handler', async () => {
    const cachedResponse = { success: true, fromCache: true };
    redisService.get.mockResolvedValue(JSON.stringify(cachedResponse));

    const mockRequest = {
      method: 'POST',
      headers: { 'idempotency-key': 'test-key-123' },
      user: { id: 'user-1' },
    };

    const mockContext = {
      switchToHttp: () => ({ getRequest: () => mockRequest }),
    } as ExecutionContext;

    const mockHandler: CallHandler = {
      handle: jest.fn().mockReturnValue(of({ success: true, fromHandler: true })),
    };

    const result$ = await interceptor.intercept(mockContext, mockHandler);
    result$.subscribe((val) => {
      expect(val).toEqual(cachedResponse);
      expect(mockHandler.handle).not.toHaveBeenCalled();
    });
  });

  it('should call handler and cache response when request is new', async () => {
    redisService.get.mockResolvedValue(null);

    const mockRequest = {
      method: 'POST',
      headers: { 'idempotency-key': 'test-key-456' },
      user: { id: 'user-1' },
    };

    const mockContext = {
      switchToHttp: () => ({ getRequest: () => mockRequest }),
    } as ExecutionContext;

    const freshResponse = { id: 1, created: true };
    const mockHandler: CallHandler = {
      handle: jest.fn().mockReturnValue(of(freshResponse)),
    };

    const result$ = await interceptor.intercept(mockContext, mockHandler);
    result$.subscribe((val) => {
      expect(val).toEqual(freshResponse);
      expect(mockHandler.handle).toHaveBeenCalled();
      expect(redisService.client.setex).toHaveBeenCalledWith(
        'idem:user-1:test-key-456',
        3600,
        JSON.stringify(freshResponse),
      );
    });
  });
});

