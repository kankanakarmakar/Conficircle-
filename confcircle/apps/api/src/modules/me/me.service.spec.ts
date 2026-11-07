import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException } from '@nestjs/common';
import { MeService } from './me.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('MeService', () => {
  let service: MeService;
  let prisma: any;

  beforeEach(async () => {
    prisma = {
      user: {
        findUnique: jest.fn(),
      },
      profile: {
        upsert: jest.fn(),
      },
      confyPointsLedger: {
        findMany: jest.fn().mockResolvedValue([]),
      },
      confyLevel: {
        findMany: jest.fn().mockResolvedValue([
          { name: 'Bronze', minPoints: 0, maxPoints: 99, order: 1, quickActionsConfig: {} },
          { name: 'Silver', minPoints: 100, maxPoints: 299, order: 2, quickActionsConfig: {} },
          { name: 'Gold', minPoints: 300, maxPoints: 1000, order: 3, quickActionsConfig: {} },
        ]),
      },
      topicProgress: {
        findMany: jest.fn().mockResolvedValue([]),
      },
      videoProgress: {
        findMany: jest.fn().mockResolvedValue([]),
      },
      assessmentAttempt: {
        findMany: jest.fn().mockResolvedValue([]),
      },
      activityEvent: {
        findMany: jest.fn().mockResolvedValue([]),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MeService,
        { provide: PrismaService, useValue: prisma },
      ],
    }).compile();

    service = module.get<MeService>(MeService);
  });

  describe('getProfile', () => {
    it('returns guest prompt if user is guest or unauthenticated', async () => {
      const res = await service.getProfile({ isGuest: true, guestRef: 'g-123' } as any);
      expect(res.isGuest).toBe(true);
      expect(res.guestRef).toBe('g-123');
      expect(res.prompt).toBeDefined();
    });

    it('returns user profile with computed Confy points and level for registered user', async () => {
      prisma.user.findUnique.mockResolvedValue({
        id: 'usr-1',
        email: 'user@example.com',
        role: 'user',
        status: 'active',
        profile: { name: 'Alice' },
      });

      prisma.confyPointsLedger.findMany.mockResolvedValue([
        { delta: 50 },
        { delta: 75 },
      ]);

      const res = await service.getProfile({ id: 'usr-1', isGuest: false } as any);

      expect(res.id).toBe('usr-1');
      expect(res.confy?.points).toBe(125);
      expect(res.confy?.level?.name).toBe('Silver');
    });

    it('throws NotFoundException if user record does not exist', async () => {
      prisma.user.findUnique.mockResolvedValue(null);

      await expect(
        service.getProfile({ id: 'usr-missing', isGuest: false } as any),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('updateProfile', () => {
    it('upserts user profile with notification consents', async () => {
      prisma.profile.upsert.mockResolvedValue({
        userId: 'usr-1',
        name: 'Alice Updated',
        notificationConsentEmail: true,
        notificationConsentWhatsapp: false,
      });

      const res = await service.updateProfile('usr-1', {
        name: 'Alice Updated',
        notificationConsentEmail: true,
      });

      expect(res.name).toBe('Alice Updated');
      expect(prisma.profile.upsert).toHaveBeenCalledWith({
        where: { userId: 'usr-1' },
        update: expect.objectContaining({ name: 'Alice Updated' }),
        create: expect.objectContaining({ name: 'Alice Updated' }),
      });
    });
  });
});
