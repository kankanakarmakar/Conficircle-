import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { HttpException, HttpStatus } from '@nestjs/common';
import { GuestService } from './guest.service';
import { RedisService } from '../../redis/redis.service';
import { PrismaService } from '../../prisma/prisma.service';
import { ErrorCode } from '../../common/dto/error.dto';

describe('GuestService', () => {
  let service: GuestService;
  let redisService: jest.Mocked<Partial<RedisService>>;
  let prismaService: jest.Mocked<Partial<PrismaService>>;
  let configService: jest.Mocked<Partial<ConfigService>>;

  beforeEach(async () => {
    redisService = {
      setWithAbsoluteTtl: jest.fn().mockResolvedValue(undefined),
      exists: jest.fn().mockResolvedValue(true),
      get: jest.fn().mockResolvedValue(null),
      ttl: jest.fn().mockResolvedValue(3500),
      checkAndDecrementQuota: jest.fn(),
      storeIdempotencyResult: jest.fn().mockResolvedValue(undefined),
      rpush: jest.fn().mockResolvedValue(undefined),
    };

    prismaService = {
      question: { findMany: jest.fn().mockResolvedValue([]) } as any,
      quickTip: { findUnique: jest.fn().mockResolvedValue({ id: 'qt-1', content: 'Tip 1', topic: { id: 'top-1', title: 'Topic 1' } }) } as any,
    };

    configService = {
      get: jest.fn().mockImplementation((key: string, defaultVal?: any) => {
        if (key === 'GUEST_TTL_SECONDS') return 3600;
        if (key === 'GUEST_QUICKTIP_QUOTA') return 3;
        if (key === 'GUEST_QUESTION_COUNT') return 3;
        return defaultVal;
      }),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GuestService,
        { provide: RedisService, useValue: redisService },
        { provide: PrismaService, useValue: prismaService },
        { provide: ConfigService, useValue: configService },
      ],
    }).compile();

    service = module.get<GuestService>(GuestService);
  });

  it('should create guest session with absolute TTL and quota', async () => {
    const session = await service.createSession({});
    expect(session.guestRef).toBeDefined();
    expect(session.quotaRemaining).toBe(3);
    expect(redisService.setWithAbsoluteTtl).toHaveBeenCalledTimes(2);
  });

  it('should consume quota atomically on openQuickTip', async () => {
    (redisService.checkAndDecrementQuota as jest.Mock).mockResolvedValue({
      type: 'ok',
      remaining: 2,
    });

    const result = await service.openQuickTip('guest-1', 'qt-1', 'idem-1');
    expect(result.quotaRemaining).toBe(2);
    expect(result.tip.id).toBe('qt-1');
  });

  it('should replay cached response on duplicate Idempotency-Key without double decrement', async () => {
    const cached = JSON.stringify({ tip: { id: 'qt-1', content: 'Tip 1' }, quotaRemaining: 2 });
    (redisService.checkAndDecrementQuota as jest.Mock).mockResolvedValue({
      type: 'idem',
      cachedResponse: cached,
    });

    const result = await service.openQuickTip('guest-1', 'qt-1', 'idem-1');
    expect(result.tip.id).toBe('qt-1');
    expect(result.quotaRemaining).toBe(2);
    expect(prismaService.quickTip?.findUnique).not.toHaveBeenCalled();
  });

  it('should throw QUOTA_EXHAUSTED when quota is 0', async () => {
    (redisService.checkAndDecrementQuota as jest.Mock).mockResolvedValue({
      type: 'quota_exhausted',
    });

    await expect(service.openQuickTip('guest-1', 'qt-1', 'idem-2')).rejects.toThrow(
      new HttpException(
        {
          code: ErrorCode.QUOTA_EXHAUSTED,
          message: 'Quick Tip quota reached for this guest session. Sign up to unlock unlimited tips!',
        },
        HttpStatus.TOO_MANY_REQUESTS,
      ),
    );
  });

  it('should throw SESSION_EXPIRED when session is not in Redis', async () => {
    (redisService.ttl as jest.Mock).mockResolvedValue(-2);

    await expect(service.openQuickTip('guest-1', 'qt-1', 'idem-3')).rejects.toThrow(
      new HttpException(
        {
          code: ErrorCode.SESSION_EXPIRED,
          message: 'Guest session has expired. Please sign in or restart your session.',
        },
        HttpStatus.FORBIDDEN,
      ),
    );
  });
});

