import {
  Injectable,
  UnauthorizedException,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { v4 as uuidv4 } from 'uuid';
import { RedisService } from '../../redis/redis.service';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateGuestSessionDto, GuestSessionResponseDto } from './guest.dto';
import { ErrorCode } from '../../common/dto/error.dto';

@Injectable()
export class GuestService {
  private readonly logger = new Logger(GuestService.name);

  constructor(
    private readonly redis: RedisService,
    private readonly prisma: PrismaService,
    private readonly configService: ConfigService,
  ) {}

  async createSession(dto: CreateGuestSessionDto): Promise<GuestSessionResponseDto> {
    const rawTtl = this.configService.get<number>('GUEST_TTL_SECONDS', 3600);
    // Hard-capped at 7200 seconds per rule 6
    const ttlSeconds = Math.min(Math.max(rawTtl, 60), 7200);
    const quota = this.configService.get<number>('GUEST_QUICKTIP_QUOTA', 3);

    // Generate opaque guest_ref (UUID) - never expose raw device ID
    const guestRef = uuidv4();
    const expiresAt = Date.now() + ttlSeconds * 1000;

    const sessionData = JSON.stringify({
      createdAt: Date.now(),
      expiresAt,
    });

    // Store in Redis with ABSOLUTE TTL
    await this.redis.setWithAbsoluteTtl(`guest:session:${guestRef}`, sessionData, ttlSeconds);
    await this.redis.setWithAbsoluteTtl(`guest:quota:quicktip:${guestRef}`, quota.toString(), ttlSeconds);

    return {
      guestRef,
      expiresAt,
      quotaRemaining: quota,
    };
  }

  async getQuestions(guestRef: string) {
    // 1. Validate session
    const sessionExists = await this.redis.exists(`guest:session:${guestRef}`);
    if (!sessionExists) {
      throw new UnauthorizedException({
        code: ErrorCode.SESSION_EXPIRED,
        message: 'Guest session has expired. Please create a new guest session.',
      });
    }

    // 2. Check if questions already selected and cached in Redis
    const cached = await this.redis.get(`guest:questions:${guestRef}`);
    if (cached) {
      return JSON.parse(cached);
    }

    // 3. Find eligible Level 4 questions
    const questionCount = this.configService.get<number>('GUEST_QUESTION_COUNT', 3);
    const questions = await this.prisma.question.findMany({
      where: {
        eligibleForGuest: true,
        active: true,
      },
      take: 20, // get pool
      include: {
        options: {
          select: { id: true, content: true }, // NEVER select isCorrect
        },
      },
    });

    // Pick random 2-3 questions
    const shuffled = [...questions].sort(() => 0.5 - Math.random());
    const selected = shuffled.slice(0, questionCount).map((q) => ({
      id: q.id,
      content: q.content,
      options: q.options,
    }));

    // Cache with remaining session TTL
    const remainingTtl = await this.redis.ttl(`guest:session:${guestRef}`);
    if (remainingTtl > 0) {
      await this.redis.setWithAbsoluteTtl(
        `guest:questions:${guestRef}`,
        JSON.stringify(selected),
        remainingTtl,
      );
    }

    // Record activity event
    await this.recordGuestEvent(guestRef, 'question.viewed', {
      questionIds: selected.map((q) => q.id),
    });

    return selected;
  }

  async openQuickTip(guestRef: string, quickTipId: string, idempotencyKey: string) {
    const remainingTtl = await this.redis.ttl(`guest:session:${guestRef}`);
    if (remainingTtl <= 0) {
      throw new HttpException(
        {
          code: ErrorCode.SESSION_EXPIRED,
          message: 'Guest session has expired. Please sign in or restart your session.',
        },
        HttpStatus.FORBIDDEN,
      );
    }

    // Atomic quota check & decrement via Lua script
    const quotaResult = await this.redis.checkAndDecrementQuota(
      guestRef,
      idempotencyKey,
      remainingTtl,
    );

    if (quotaResult.type === 'session_expired') {
      throw new HttpException(
        {
          code: ErrorCode.SESSION_EXPIRED,
          message: 'Guest session has expired',
        },
        HttpStatus.FORBIDDEN,
      );
    }

    if (quotaResult.type === 'quota_exhausted') {
      throw new HttpException(
        {
          code: ErrorCode.QUOTA_EXHAUSTED,
          message: 'Quick Tip quota reached for this guest session. Sign up to unlock unlimited tips!',
        },
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    if (quotaResult.type === 'idem') {
      return JSON.parse(quotaResult.cachedResponse);
    }

    // Fetch quick tip content
    const tip = await this.prisma.quickTip.findUnique({
      where: { id: quickTipId },
      include: { topic: { select: { id: true, title: true } } },
    });

    if (!tip) {
      throw new HttpException(
        {
          code: ErrorCode.NOT_FOUND,
          message: 'Quick Tip not found',
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const response = {
      tip: {
        id: tip.id,
        content: tip.content,
        topic: tip.topic,
      },
      quotaRemaining: quotaResult.remaining,
    };

    // Store idempotency response
    await this.redis.storeIdempotencyResult(`guest_quicktip:${idempotencyKey}`, response, remainingTtl);

    // Record permitted activity event
    await this.recordGuestEvent(guestRef, 'quicktip.viewed', {
      quickTipId,
      sourceEventId: `guest_${guestRef}_qt_${quickTipId}`,
    });

    return response;
  }

  private async recordGuestEvent(guestRef: string, type: string, payload: Record<string, any>) {
    try {
      const remainingTtl = await this.redis.ttl(`guest:session:${guestRef}`);
      if (remainingTtl > 0) {
        const event = {
          type,
          payload,
          sourceEventId: payload.sourceEventId || `${guestRef}_${type}_${Date.now()}`,
          timestamp: Date.now(),
        };
        await this.redis.rpush(`guest:events:${guestRef}`, JSON.stringify(event));
      }
    } catch (e: any) {
      this.logger.warn(`Could not log guest event: ${e.message}`);
    }
  }
}

