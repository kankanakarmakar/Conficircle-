import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { BadRequestException } from '@nestjs/common';
import { VideosService } from './videos.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('VideosService', () => {
  let service: VideosService;
  let prismaService: any;
  let configService: any;

  beforeEach(async () => {
    prismaService = {
      videoSolution: { findUnique: jest.fn() },
      videoProgress: { findUnique: jest.fn(), upsert: jest.fn() },
      confyPointsLedger: { create: jest.fn() },
      topicProgress: { upsert: jest.fn() },
      $transaction: jest.fn().mockImplementation(async (callback) => callback(prismaService)),
    };

    configService = {
      get: jest.fn().mockImplementation((key: string, defaultVal?: any) => {
        if (key === 'VIDEO_COMPLETION_THRESHOLD') return 0.9;
        if (key === 'VIDEO_URL_SIGN_SECRET') return 'test-secret';
        if (key === 'VIDEO_URL_TTL_SECONDS') return 300;
        return defaultVal;
      }),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        VideosService,
        { provide: PrismaService, useValue: prismaService },
        { provide: ConfigService, useValue: configService },
      ],
    }).compile();

    service = module.get<VideosService>(VideosService);
  });

  it('should reject impossible position jumps (position > duration + 5s)', async () => {
    prismaService.videoSolution.findUnique.mockResolvedValue({
      id: 'vid-1',
      title: 'Video 1',
      durationSec: 100,
    });

    await expect(
      service.updateProgress('vid-1', 'user-1', { positionSec: 120 }), // 120 > 105
    ).rejects.toThrow(BadRequestException);
  });

  it('should award Confy points once when video reaches completion threshold (90%)', async () => {
    prismaService.videoSolution.findUnique.mockResolvedValue({
      id: 'vid-1',
      topicId: 'top-1',
      title: 'Video 1',
      durationSec: 100,
    });

    prismaService.videoProgress.findUnique.mockResolvedValue(null); // not previously completed

    const result = await service.updateProgress('vid-1', 'user-1', { positionSec: 92 }); // 92% >= 90%
    expect(result.completed).toBe(true);
    expect(result.pointsAwarded).toBe(true);
    expect(prismaService.confyPointsLedger.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          userId: 'user-1',
          delta: 15,
          refEventId: 'video_vid-1_user_user-1',
        }),
      }),
    );
  });

  it('should not award duplicate Confy points if video was already completed', async () => {
    prismaService.videoSolution.findUnique.mockResolvedValue({
      id: 'vid-1',
      topicId: 'top-1',
      title: 'Video 1',
      durationSec: 100,
    });

    prismaService.videoProgress.findUnique.mockResolvedValue({
      completed: true, // Already completed
    });

    const result = await service.updateProgress('vid-1', 'user-1', { positionSec: 95 });
    expect(result.pointsAwarded).toBe(false);
    expect(prismaService.confyPointsLedger.create).not.toHaveBeenCalled();
  });
});

