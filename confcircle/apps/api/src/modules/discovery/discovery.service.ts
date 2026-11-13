import {
  Injectable,
  UnauthorizedException,
  NotFoundException,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { PrismaService } from '../../prisma/prisma.service';
import { RedisService } from '../../redis/redis.service';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { ErrorCode } from '../../common/dto/error.dto';
import {
  QuestionCardDto,
  DiscoveryBatchResponseDto,
  GuestShuffleDto,
  RegisteredShuffleDto,
  SaveProblemProfileDto,
  UpdateProblemProfileDto,
  RecordDiscoveryEventDto,
  ConcernPromptItemDto,
  QuestionDetailResponseDto,
} from './discovery.dto';

@Injectable()
export class DiscoveryService {
  private readonly logger = new Logger(DiscoveryService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
  ) {}

  // ─────────────────────────────────────────────────────────────
  // 1. Guest Discovery Batch (7–8 Level 4 Questions)
  // ─────────────────────────────────────────────────────────────
  async getGuestBatch(
    guestRef: string,
    requestedLimit?: number,
    previousBatchId?: string,
  ): Promise<DiscoveryBatchResponseDto> {
    // Validate guest session in Redis
    const sessionExists = await this.redis.exists(`guest:session:${guestRef}`);
    if (!sessionExists) {
      throw new UnauthorizedException({
        code: ErrorCode.SESSION_EXPIRED,
        message: 'Guest session expired or invalid. Please initialize a guest session.',
      });
    }

    // Default 8; bound strictly between 7 and 8
    const limit = requestedLimit ? Math.min(Math.max(requestedLimit, 7), 8) : 8;

    // Hard eligibility: published, guest-eligible, valid taxonomy mapping
    const candidates = await this.prisma.questionPrompt.findMany({
      where: {
        publishStatus: 'published',
        guestEligible: true,
        taxonomyNodeId: { not: undefined },
      },
      include: {
        taxonomyNode: true,
      },
    });

    if (!candidates || candidates.length === 0) {
      // Fallback pool from Question model if QuestionPrompt not yet populated
      return this.buildFallbackGuestBatch(guestRef, limit);
    }

    // Filter out previous batch items if provided
    let excludedIds: string[] = [];
    if (previousBatchId) {
      const prevBatch = await this.prisma.discoveryBatch.findUnique({
        where: { id: previousBatchId },
      });
      if (prevBatch && Array.isArray(prevBatch.itemIds)) {
        excludedIds = prevBatch.itemIds as string[];
      }
    }

    const eligible = candidates.filter((q) => !excludedIds.includes(q.id));
    const pool = eligible.length >= limit ? eligible : candidates;

    // Diverse random sampling across taxonomy branches
    const sampled = this.sampleDiverseQuestions(pool, limit);
    const batchId = uuidv4();

    // Store batch for repeat suppression
    const remainingTtl = await this.redis.ttl(`guest:session:${guestRef}`);
    const ttl = remainingTtl > 0 ? remainingTtl : 3600;

    await this.prisma.discoveryBatch.create({
      data: {
        id: batchId,
        audience: 'guest',
        guestRef,
        itemIds: sampled.map((q) => q.id),
        expiresAt: new Date(Date.now() + ttl * 1000),
      },
    });

    // Record discovery_batch_served
    await this.recordGuestDiscoveryEvent(guestRef, 'impression', sampled[0]?.id || batchId, {
      batchId,
      audience: 'guest',
      questionIds: sampled.map((q) => q.id),
      timestamp: Date.now(),
    });

    // Format output: Level 4 prompt text and public question IDs only. NO L0-L3 NAMES!
    const items: QuestionCardDto[] = sampled.map((q) => ({
      questionId: q.id,
      prompt: q.promptText,
      shortDescription: q.shortDescription || undefined,
      displayAsset: q.displayAsset || null,
    }));

    return {
      batchId,
      audience: 'guest',
      items,
      expiresAt: Date.now() + ttl * 1000,
    };
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Guest Shuffle (Fresh 7–8 Level 4 Questions)
  // ─────────────────────────────────────────────────────────────
  async shuffleGuestBatch(
    guestRef: string,
    dto: GuestShuffleDto,
  ): Promise<DiscoveryBatchResponseDto> {
    const sessionExists = await this.redis.exists(`guest:session:${guestRef}`);
    if (!sessionExists) {
      throw new UnauthorizedException({
        code: ErrorCode.SESSION_EXPIRED,
        message: 'Guest session expired.',
      });
    }

    const limit = 8; // Default 7-8
    const excluded = new Set<string>(dto.excludedIds || []);

    if (dto.previousBatchId) {
      const prev = await this.prisma.discoveryBatch.findUnique({
        where: { id: dto.previousBatchId },
      });
      if (prev && Array.isArray(prev.itemIds)) {
        for (const id of prev.itemIds as string[]) {
          excluded.add(id);
        }
      }
    }

    // Fetch published & guest-eligible
    const candidates = await this.prisma.questionPrompt.findMany({
      where: {
        publishStatus: 'published',
        guestEligible: true,
      },
      include: {
        taxonomyNode: true,
      },
    });

    let pool = candidates.filter((c) => !excluded.has(c.id));
    if (pool.length < limit) {
      pool = candidates; // fallback if candidate pool exhausted
    }

    const sampled = this.sampleDiverseQuestions(pool, limit);
    const batchId = uuidv4();
    const remainingTtl = await this.redis.ttl(`guest:session:${guestRef}`);
    const ttl = remainingTtl > 0 ? remainingTtl : 3600;

    await this.prisma.discoveryBatch.create({
      data: {
        id: batchId,
        audience: 'guest',
        guestRef,
        itemIds: sampled.map((q) => q.id),
        expiresAt: new Date(Date.now() + ttl * 1000),
      },
    });

    // Record discovery_shuffle_tapped (does not count as content view)
    await this.recordGuestDiscoveryEvent(guestRef, 'shuffle', sampled[0]?.id || batchId, {
      batchId,
      previousBatchId: dto.previousBatchId,
      timestamp: Date.now(),
    });

    const items: QuestionCardDto[] = sampled.map((q) => ({
      questionId: q.id,
      prompt: q.promptText,
      shortDescription: q.shortDescription || undefined,
      displayAsset: q.displayAsset || null,
    }));

    return {
      batchId,
      audience: 'guest',
      items,
      expiresAt: Date.now() + ttl * 1000,
    };
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Registered Discovery Batch (5–6 Level 4 Questions)
  // ─────────────────────────────────────────────────────────────
  async getRegisteredBatch(
    userId: string,
    requestedLimit?: number,
    context?: string,
  ): Promise<DiscoveryBatchResponseDto> {
    // Default 6; bound strictly between 5 and 6
    const limit = requestedLimit ? Math.min(Math.max(requestedLimit, 5), 6) : 6;

    // Hard filter: published, registeredEligible, valid parent mapping
    const candidates = await this.prisma.questionPrompt.findMany({
      where: {
        publishStatus: 'published',
        registeredEligible: true,
        taxonomyNodeId: { not: undefined },
      },
      include: {
        taxonomyNode: {
          include: {
            parent: {
              include: { parent: true },
            },
          },
        },
      },
    });

    if (!candidates || candidates.length === 0) {
      return this.buildFallbackRegisteredBatch(userId, limit);
    }

    // Load user's problem profile concerns (hidden mapping)
    const userConcerns = await this.prisma.userProblemProfile.findMany({
      where: {
        userId,
        status: 'active',
      },
      include: {
        concernPrompt: {
          include: {
            taxonomyNode: true,
          },
        },
      },
    });

    // Extract target taxonomy node IDs (L2/L1) mapped from user's selected concerns
    const matchedNodeIds = new Set<string>();
    for (const uc of userConcerns) {
      if (uc.concernPrompt?.taxonomyNodeId) {
        matchedNodeIds.add(uc.concernPrompt.taxonomyNodeId);
      }
    }

    // Load recent impressions and dismissals for penalty scoring
    const recentEvents = await this.prisma.discoveryEvent.findMany({
      where: {
        userId,
        createdAt: {
          gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // 7 days window
        },
      },
      select: {
        questionId: true,
        eventType: true,
      },
    });

    const recentSeenCount = new Map<string, number>();
    const dismissedSet = new Set<string>();
    for (const ev of recentEvents) {
      if (ev.eventType === 'impression' || ev.eventType === 'selection') {
        recentSeenCount.set(ev.questionId, (recentSeenCount.get(ev.questionId) || 0) + 1);
      }
      if (ev.eventType === 'dismissal') {
        dismissedSet.add(ev.questionId);
      }
    }

    // Configurable scoring weights:
    // score = profile_match + priority_boost + editorial_boost + freshness_boost + exploration_bonus - recent_seen_penalty - dismissed_penalty
    const profileMatchWeight = 4.0;
    const editorialBoostWeight = 2.0;
    const recentSeenPenaltyWeight = 1.5;
    const dismissedPenaltyWeight = 10.0;
    const explorationBonusWeight = 1.0;

    const scoredCandidates = candidates.map((q) => {
      let score = 5.0; // base score
      let isProfileMatch = false;

      // Check if mapped up hierarchy to user's selected concern nodes
      const l3Node = q.taxonomyNode;
      const l2Node = l3Node?.parent;
      const l1Node = l2Node?.parent;

      if (
        (l3Node && matchedNodeIds.has(l3Node.id)) ||
        (l2Node && matchedNodeIds.has(l2Node.id)) ||
        (l1Node && matchedNodeIds.has(l1Node.id))
      ) {
        score += profileMatchWeight;
        isProfileMatch = true;
      }

      // Editorial boost
      score += (q.editorialBoost || 0) * editorialBoostWeight;

      // Penalties
      const seenTimes = recentSeenCount.get(q.id) || 0;
      score -= seenTimes * recentSeenPenaltyWeight;

      if (dismissedSet.has(q.id)) {
        score -= dismissedPenaltyWeight;
      }

      // Exploration bonus (slight jitter)
      score += Math.random() * explorationBonusWeight;

      return {
        question: q,
        score: Math.max(0.1, score),
        isProfileMatch,
      };
    });

    // Weighted random sampling with diversity constraints
    const sampled = this.sampleWeightedDiverse(scoredCandidates, limit);
    const batchId = uuidv4();

    await this.prisma.discoveryBatch.create({
      data: {
        id: batchId,
        audience: 'registered',
        userId,
        itemIds: sampled.map((s) => s.question.id),
        requestContext: context ? { context } : {},
      },
    });

    // Record discovery_batch_served
    await this.prisma.discoveryEvent.create({
      data: {
        audience: 'registered',
        userId,
        questionId: sampled[0]?.question.id || uuidv4(),
        eventType: 'impression',
        metadata: {
          batchId,
          audience: 'registered',
          questionIds: sampled.map((s) => s.question.id),
          timestamp: Date.now(),
        },
      },
    });

    // Consumer DTO: Level 4 question prompts ONLY. Safe label if profile match. NO L0-L3 names!
    const items: QuestionCardDto[] = sampled.map((s) => ({
      questionId: s.question.id,
      prompt: s.question.promptText,
      shortDescription: s.question.shortDescription || undefined,
      displayAsset: s.question.displayAsset || null,
      safeReasonLabel: s.isProfileMatch ? 'Based on what you selected' : undefined,
    }));

    return {
      batchId,
      audience: 'registered',
      items,
    };
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Registered Shuffle (Fresh 5–6 Level 4 Questions)
  // ─────────────────────────────────────────────────────────────
  async shuffleRegisteredBatch(
    userId: string,
    dto: RegisteredShuffleDto,
  ): Promise<DiscoveryBatchResponseDto> {
    const limit = 6;
    const excluded = new Set<string>(dto.excludedIds || []);

    if (dto.previousBatchId) {
      const prev = await this.prisma.discoveryBatch.findUnique({
        where: { id: dto.previousBatchId },
      });
      if (prev && Array.isArray(prev.itemIds)) {
        for (const id of prev.itemIds as string[]) {
          excluded.add(id);
        }
      }
    }

    const candidates = await this.prisma.questionPrompt.findMany({
      where: {
        publishStatus: 'published',
        registeredEligible: true,
      },
      include: {
        taxonomyNode: true,
      },
    });

    let pool = candidates.filter((c) => !excluded.has(c.id));
    if (pool.length < limit) {
      pool = candidates;
    }

    const sampled = this.sampleDiverseQuestions(pool, limit);
    const batchId = uuidv4();

    await this.prisma.discoveryBatch.create({
      data: {
        id: batchId,
        audience: 'registered',
        userId,
        itemIds: sampled.map((q) => q.id),
      },
    });

    // Record discovery_shuffle_tapped
    await this.prisma.discoveryEvent.create({
      data: {
        audience: 'registered',
        userId,
        questionId: sampled[0]?.id || uuidv4(),
        eventType: 'shuffle',
        metadata: {
          batchId,
          previousBatchId: dto.previousBatchId,
          timestamp: Date.now(),
        },
      },
    });

    const items: QuestionCardDto[] = sampled.map((q) => ({
      questionId: q.id,
      prompt: q.promptText,
      shortDescription: q.shortDescription || undefined,
      displayAsset: q.displayAsset || null,
    }));

    return {
      batchId,
      audience: 'registered',
      items,
    };
  }

  // ─────────────────────────────────────────────────────────────
  // 5. Question Detail & Content Entitlement Access
  // ─────────────────────────────────────────────────────────────
  async getQuestionDetail(
    questionId: string,
    user?: AuthenticatedUser,
  ): Promise<QuestionDetailResponseDto> {
    const question = await this.prisma.questionPrompt.findUnique({
      where: { id: questionId },
      include: {
        taxonomyNode: true,
      },
    });

    if (!question) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Question prompt not found',
      });
    }

    const isRegistered = user && !user.isGuest && Boolean(user.id);
    let guestQuotaRemaining = 0;

    if (!isRegistered && user?.guestRef) {
      const qStr = await this.redis.get(`guest:quota:quicktip:${user.guestRef}`);
      guestQuotaRemaining = qStr ? parseInt(qStr, 10) : 0;
    }

    // Permitted content actions based on role and quotas
    const permittedContentActions: QuestionDetailResponseDto['permittedContentActions'] = [
      {
        actionType: 'quicktip',
        enabled: isRegistered || guestQuotaRemaining > 0,
        reason: !isRegistered && guestQuotaRemaining <= 0 ? 'QUOTA_EXHAUSTED' : undefined,
        quotaRemaining: !isRegistered ? guestQuotaRemaining : undefined,
      },
      {
        actionType: 'video',
        enabled: isRegistered,
        reason: !isRegistered ? 'ACCOUNT_REQUIRED' : undefined,
      },
      {
        actionType: 'assessment',
        enabled: isRegistered,
        reason: !isRegistered ? 'ACCOUNT_REQUIRED' : undefined,
      },
    ];

    // Fetch mapped quick tips (or general published tips)
    const quickTips = await this.prisma.quickTip.findMany({
      where: { published: true },
      take: 3,
      orderBy: { order: 'asc' },
    });

    // Fetch mapped video solutions
    const videos = await this.prisma.videoSolution.findMany({
      where: { published: true },
      take: 2,
    });

    // Fetch assessments
    const assessments = await this.prisma.assessment.findMany({
      where: { active: true },
      take: 1,
      include: { questions: true },
    });

    return {
      questionId: question.id,
      prompt: question.promptText,
      shortDescription: question.shortDescription || undefined,
      displayAsset: question.displayAsset || null,
      permittedContentActions,
      quickTips: quickTips.map((qt) => ({
        id: qt.id,
        content: qt.content,
        order: qt.order,
      })),
      videoSolutions: videos.map((v) => ({
        id: v.id,
        title: v.title,
        durationSec: v.durationSec,
        requiresRegistration: true,
      })),
      assessments: assessments.map((a) => ({
        id: a.id,
        title: a.title,
        questionCount: a.questions.length,
        requiresRegistration: true,
      })),
    };
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Problem Profile & Personalisation
  // ─────────────────────────────────────────────────────────────
  async getCuratedConcerns(): Promise<ConcernPromptItemDto[]> {
    const concerns = await this.prisma.concernPrompt.findMany({
      where: { active: true },
      orderBy: { order: 'asc' },
      select: {
        id: true,
        promptText: true,
        order: true,
      },
    });

    return concerns;
  }

  async saveProblemProfile(
    userId: string,
    dto: SaveProblemProfileDto,
  ) {
    if (!dto.concernPromptIds || dto.concernPromptIds.length === 0) {
      throw new BadRequestException({
        code: ErrorCode.VALIDATION_FAILED,
        message: 'At least one concern prompt ID must be selected',
      });
    }

    // Verify valid concern prompt IDs
    const validConcerns = await this.prisma.concernPrompt.findMany({
      where: {
        id: { in: dto.concernPromptIds },
        active: true,
      },
    });

    if (validConcerns.length === 0) {
      throw new BadRequestException({
        code: ErrorCode.VALIDATION_FAILED,
        message: 'No valid concern prompt IDs found',
      });
    }

    // Upsert or replace active user concerns
    for (const concern of validConcerns) {
      const existing = await this.prisma.userProblemProfile.findFirst({
        where: {
          userId,
          concernPromptId: concern.id,
        },
      });

      if (existing) {
        await this.prisma.userProblemProfile.update({
          where: { id: existing.id },
          data: {
            status: 'active',
            priority: dto.priority || 1,
            consentGiven: true,
          },
        });
      } else {
        await this.prisma.userProblemProfile.create({
          data: {
            userId,
            concernPromptId: concern.id,
            priority: dto.priority || 1,
            status: 'active',
            consentGiven: true,
          },
        });
      }
    }

    return {
      message: 'Problem profile saved successfully',
      activeConcernCount: validConcerns.length,
      concerns: validConcerns.map((c) => ({
        id: c.id,
        promptText: c.promptText,
      })),
    };
  }

  async updateProblemProfile(
    userId: string,
    id: string,
    dto: UpdateProblemProfileDto,
  ) {
    const record = await this.prisma.userProblemProfile.findFirst({
      where: { id, userId },
      include: { concernPrompt: true },
    });

    if (!record) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Problem profile concern not found',
      });
    }

    const updated = await this.prisma.userProblemProfile.update({
      where: { id },
      data: {
        status: dto.status || record.status,
        priority: dto.priority ?? record.priority,
      },
      include: {
        concernPrompt: true,
      },
    });

    return {
      id: updated.id,
      promptText: updated.concernPrompt.promptText,
      status: updated.status,
      priority: updated.priority,
    };
  }

  async getUserProblemProfile(userId: string) {
    const profiles = await this.prisma.userProblemProfile.findMany({
      where: { userId },
      include: {
        concernPrompt: true,
      },
      orderBy: { createdAt: 'desc' },
    });

    return profiles.map((p) => ({
      id: p.id,
      concernPromptId: p.concernPromptId,
      promptText: p.concernPrompt.promptText,
      status: p.status,
      priority: p.priority,
      createdAt: p.createdAt,
    }));
  }

  // ─────────────────────────────────────────────────────────────
  // 7. Event Recording
  // ─────────────────────────────────────────────────────────────
  async recordEvent(user: AuthenticatedUser | undefined, dto: RecordDiscoveryEventDto) {
    const audience = user && !user.isGuest ? 'registered' : 'guest';
    const userId = user && !user.isGuest ? user.id : undefined;
    const guestRef = user?.guestRef;

    if (audience === 'registered') {
      await this.prisma.discoveryEvent.create({
        data: {
          audience,
          userId,
          questionId: dto.questionId,
          eventType: dto.eventType,
          metadata: dto.metadata || {},
        },
      });
    } else if (guestRef) {
      await this.recordGuestDiscoveryEvent(guestRef, dto.eventType, dto.questionId, dto.metadata);
    }

    return { success: true };
  }

  // ─────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────
  private async recordGuestDiscoveryEvent(
    guestRef: string,
    eventType: string,
    questionId: string,
    metadata?: any,
  ) {
    const event = JSON.stringify({
      eventType,
      questionId,
      metadata,
      createdAt: Date.now(),
    });
    await this.redis.rpush(`guest:events:${guestRef}`, event);
  }

  private sampleDiverseQuestions<T extends { taxonomyNodeId?: string }>(
    items: T[],
    count: number,
  ): T[] {
    if (items.length <= count) return [...items];

    // Group by taxonomyNodeId to ensure cross-branch diversity
    const groups = new Map<string, T[]>();
    for (const item of items) {
      const key = item.taxonomyNodeId || 'general';
      if (!groups.has(key)) groups.set(key, []);
      groups.get(key)!.push(item);
    }

    // Round-robin selection
    const selected: T[] = [];
    const groupArrays = Array.from(groups.values()).map((arr) => [...arr].sort(() => 0.5 - Math.random()));

    let index = 0;
    while (selected.length < count && groupArrays.some((arr) => arr.length > 0)) {
      const group = groupArrays[index % groupArrays.length];
      if (group.length > 0) {
        selected.push(group.pop()!);
      }
      index++;
    }

    return selected;
  }

  private sampleWeightedDiverse<T extends { question: { taxonomyNodeId?: string }; score: number }>(
    scoredItems: T[],
    count: number,
  ): T[] {
    if (scoredItems.length <= count) return [...scoredItems];

    // Soft-max or roulette-wheel weighted random sampling
    const remaining = [...scoredItems];
    const selected: T[] = [];

    while (selected.length < count && remaining.length > 0) {
      const totalScore = remaining.reduce((acc, curr) => acc + curr.score, 0);
      let rand = Math.random() * totalScore;

      let pickedIndex = 0;
      for (let i = 0; i < remaining.length; i++) {
        rand -= remaining[i].score;
        if (rand <= 0) {
          pickedIndex = i;
          break;
        }
      }

      selected.push(remaining[pickedIndex]);
      remaining.splice(pickedIndex, 1);
    }

    return selected;
  }

  private buildFallbackGuestBatch(guestRef: string, limit: number): DiscoveryBatchResponseDto {
    const fallbackPrompts = [
      'How do I stop overthinking in group meetings and actually speak up?',
      'What can I do when imposter syndrome kicks in before a presentation?',
      'How do I make tough decisions without constantly second-guessing myself?',
      'How can I stop comparing my career journey to my peers on social media?',
      'How do I set firm boundaries with friends without feeling guilty?',
      'How should I answer "Tell me about a time you failed" in an interview?',
      'What is a 2-minute daily routine to reset when stress feels overwhelming?',
      'How can I retain what I study without having to re-read everything twice?',
    ];

    const items: QuestionCardDto[] = fallbackPrompts.slice(0, limit).map((p, idx) => ({
      questionId: `l4-guest-${idx + 1}`,
      prompt: p,
      shortDescription: 'Practical confidence tool',
      displayAsset: null,
    }));

    return {
      batchId: uuidv4(),
      audience: 'guest',
      items,
      expiresAt: Date.now() + 3600000,
    };
  }

  private buildFallbackRegisteredBatch(userId: string, limit: number): DiscoveryBatchResponseDto {
    const fallbackPrompts = [
      'How do I handle an awkward silence in a 1-on-1 conversation?',
      'What should I do right after making a visible mistake at work or college?',
      'How do I ask senior leaders for guidance without feeling like a burden?',
      'How can I stay calm and articulate under unexpected questioning?',
      'How do I stop overthinking in group meetings and actually speak up?',
      'What can I do when imposter syndrome kicks in before a presentation?',
    ];

    const items: QuestionCardDto[] = fallbackPrompts.slice(0, limit).map((p, idx) => ({
      questionId: `l4-reg-${idx + 1}`,
      prompt: p,
      shortDescription: 'Confidence and influence insight',
      displayAsset: null,
      safeReasonLabel: idx === 0 ? 'Based on what you selected' : undefined,
    }));

    return {
      batchId: uuidv4(),
      audience: 'registered',
      items,
    };
  }
}

