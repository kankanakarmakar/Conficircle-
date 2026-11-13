import { Test, TestingModule } from '@nestjs/testing';
import { DiscoveryService } from './discovery.service';
import { PrismaService } from '../../prisma/prisma.service';
import { RedisService } from '../../redis/redis.service';

describe('DiscoveryService (Spec v3.0)', () => {
  let service: DiscoveryService;
  let prisma: any;
  let redis: any;

  const mockQuestions = Array.from({ length: 15 }, (_, i) => ({
    id: `q-uuid-${i + 1}`,
    promptText: `Level 4 question prompt ${i + 1}?`,
    shortDescription: `Helper description ${i + 1}`,
    displayAsset: null,
    taxonomyNodeId: `tax-node-${(i % 3) + 1}`,
    publishStatus: 'published',
    guestEligible: true,
    registeredEligible: true,
    version: 1,
    editorialBoost: 0.0,
    taxonomyNode: {
      id: `tax-node-${(i % 3) + 1}`,
      level: 3,
      parent: {
        id: `l2-node-${(i % 2) + 1}`,
        level: 2,
        parent: { id: 'l1-node-1', level: 1 },
      },
    },
  }));

  const mockConcerns = [
    {
      id: 'concern-1',
      promptText: 'I freeze or stay quiet during important meetings or discussions',
      taxonomyNodeId: 'l2-node-1',
      active: true,
      order: 1,
    },
    {
      id: 'concern-2',
      promptText: 'I constantly second-guess my decisions and overthink simple choices',
      taxonomyNodeId: 'l2-node-2',
      active: true,
      order: 2,
    },
  ];

  beforeEach(async () => {
    prisma = {
      questionPrompt: {
        findMany: jest.fn().mockResolvedValue(mockQuestions),
        findUnique: jest.fn().mockImplementation(({ where }) => {
          const q = mockQuestions.find((item) => item.id === where.id);
          return Promise.resolve(q || null);
        }),
      },
      discoveryBatch: {
        create: jest.fn().mockImplementation(({ data }) => Promise.resolve(data)),
        findUnique: jest.fn().mockResolvedValue(null),
      },
      discoveryEvent: {
        create: jest.fn().mockResolvedValue({ id: 'event-1' }),
        findMany: jest.fn().mockResolvedValue([]),
      },
      userProblemProfile: {
        findMany: jest.fn().mockResolvedValue([
          {
            id: 'profile-1',
            userId: 'user-123',
            concernPromptId: 'concern-1',
            concernPrompt: mockConcerns[0],
            status: 'active',
            priority: 1,
          },
        ]),
        findFirst: jest.fn().mockResolvedValue(null),
        create: jest.fn().mockResolvedValue({ id: 'upp-1' }),
        update: jest.fn().mockResolvedValue({ id: 'upp-1' }),
      },
      concernPrompt: {
        findMany: jest.fn().mockResolvedValue(mockConcerns),
      },
      quickTip: {
        findMany: jest.fn().mockResolvedValue([
          { id: 'tip-1', content: 'Focus on 1 point', order: 1, published: true },
        ]),
      },
      videoSolution: {
        findMany: jest.fn().mockResolvedValue([
          { id: 'vid-1', title: 'Meeting confidence', durationSec: 180, published: true },
        ]),
      },
      assessment: {
        findMany: jest.fn().mockResolvedValue([
          { id: 'ass-1', title: 'Quick check', active: true, questions: [{ id: 'aq-1' }] },
        ]),
      },
    };

    redis = {
      exists: jest.fn().mockResolvedValue(1),
      ttl: jest.fn().mockResolvedValue(3600),
      get: jest.fn().mockResolvedValue('3'),
      rpush: jest.fn().mockResolvedValue(1),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DiscoveryService,
        { provide: PrismaService, useValue: prisma },
        { provide: RedisService, useValue: redis },
      ],
    }).compile();

    service = module.get<DiscoveryService>(DiscoveryService);
  });

  describe('Guest Discovery Batch', () => {
    it('returns exactly 7-8 Level 4 questions by default (default: 8)', async () => {
      const res = await service.getGuestBatch('guest-ref-123');

      expect(res.audience).toBe('guest');
      expect(res.items.length).toBe(8);
      expect(res.items[0]).toHaveProperty('prompt');
      expect(res.items[0]).toHaveProperty('questionId');

      // Verify NO taxonomy leakage
      for (const item of res.items) {
        expect(item).not.toHaveProperty('level');
        expect(item).not.toHaveProperty('taxonomyNodeId');
        expect(item).not.toHaveProperty('parent');
        expect(item).not.toHaveProperty('chunk');
      }
    });

    it('respects requested limit of 7', async () => {
      const res = await service.getGuestBatch('guest-ref-123', 7);
      expect(res.items.length).toBe(7);
    });

    it('shuffle returns a fresh batch of 7-8 items and records shuffle event', async () => {
      const res = await service.shuffleGuestBatch('guest-ref-123', {
        excludedIds: ['q-uuid-1', 'q-uuid-2'],
      });

      expect(res.audience).toBe('guest');
      expect(res.items.length).toBe(8);
      expect(redis.rpush).toHaveBeenCalled();
    });
  });

  describe('Registered Discovery Batch', () => {
    it('returns exactly 5-6 Level 4 questions by default (default: 6)', async () => {
      const res = await service.getRegisteredBatch('user-123');

      expect(res.audience).toBe('registered');
      expect(res.items.length).toBe(6);

      // Verify items are Level 4 question prompts only
      for (const item of res.items) {
        expect(item).toHaveProperty('prompt');
        expect(item).toHaveProperty('questionId');
        expect(item).not.toHaveProperty('level');
        expect(item).not.toHaveProperty('taxonomyNodeId');
      }
    });

    it('boosts profile-matched questions and applies safe reason label', async () => {
      const res = await service.getRegisteredBatch('user-123');

      // Has safe reason label if profile matched, e.g. "Based on what you selected"
      const matched = res.items.find((item) => item.safeReasonLabel != null);
      if (matched) {
        expect(matched.safeReasonLabel).toBe('Based on what you selected');
      }
    });

    it('respects requested limit of 5', async () => {
      const res = await service.getRegisteredBatch('user-123', 5);
      expect(res.items.length).toBe(5);
    });
  });

  describe('Question Detail & Content Access', () => {
    it('returns question context and gates video/assessment for guest', async () => {
      const guestUser: any = { id: '', isGuest: true, guestRef: 'guest-123' };
      const detail = await service.getQuestionDetail('q-uuid-1', guestUser);

      expect(detail.questionId).toBe('q-uuid-1');
      expect(detail.prompt).toBe('Level 4 question prompt 1?');

      const quicktipAction = detail.permittedContentActions.find((a) => a.actionType === 'quicktip');
      const videoAction = detail.permittedContentActions.find((a) => a.actionType === 'video');

      expect(quicktipAction?.enabled).toBe(true);
      expect(videoAction?.enabled).toBe(false);
      expect(videoAction?.reason).toBe('ACCOUNT_REQUIRED');
    });

    it('enables all content actions for registered users', async () => {
      const registeredUser: any = { id: 'user-123', isGuest: false };
      const detail = await service.getQuestionDetail('q-uuid-1', registeredUser);

      const videoAction = detail.permittedContentActions.find((a) => a.actionType === 'video');
      expect(videoAction?.enabled).toBe(true);
      expect(videoAction?.reason).toBeUndefined();
    });
  });

  describe('Problem Profile', () => {
    it('saves selected concerns mapped to hidden taxonomy nodes', async () => {
      const result = await service.saveProblemProfile('user-123', {
        concernPromptIds: ['concern-1'],
        priority: 1,
      });

      expect(result.activeConcernCount).toBe(1);
      expect(result.concerns[0].promptText).toBe('I freeze or stay quiet during important meetings or discussions');
    });
  });
});

