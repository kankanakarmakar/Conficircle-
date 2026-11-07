import {
  Injectable,
  NotFoundException,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';
import { PrismaService } from '../../prisma/prisma.service';
import { VideoProgressDto } from './videos.dto';
import { ErrorCode } from '../../common/dto/error.dto';

@Injectable()
export class VideosService {
  private readonly logger = new Logger(VideosService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly configService: ConfigService,
  ) {}

  async getVideo(id: string) {
    const video = await this.prisma.videoSolution.findUnique({
      where: { id },
      include: { topic: true },
    });

    if (!video) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Video not found',
      });
    }

    return video;
  }

  async getPlaybackUrl(videoId: string, userId: string) {
    const video = await this.getVideo(videoId);

    const ttlSeconds = this.configService.get<number>('VIDEO_URL_TTL_SECONDS', 300); // 5 min
    const expiresAt = Math.floor(Date.now() / 1000) + ttlSeconds;
    const secret = this.configService.get<string>('VIDEO_URL_SIGN_SECRET', 'default-video-sign-secret');

    // HMAC-SHA256 signature bound to videoId, userId, and expiration
    const payload = `${videoId}:${userId}:${expiresAt}`;
    const signature = crypto.createHmac('sha256', secret).update(payload).digest('hex');

    const playbackUrl = `https://stream.confcircle.internal/videos/${video.storageKey}?exp=${expiresAt}&uid=${userId}&sig=${signature}`;

    return {
      playbackUrl,
      expiresAt: expiresAt * 1000,
      durationSec: video.durationSec,
      title: video.title,
    };
  }

  async updateProgress(videoId: string, userId: string, dto: VideoProgressDto) {
    const video = await this.getVideo(videoId);

    // Rule 5: Reject impossible position jumps
    if (dto.positionSec > video.durationSec + 5) {
      throw new BadRequestException({
        code: ErrorCode.VALIDATION_FAILED,
        message: `Position ${dto.positionSec}s exceeds video duration (${video.durationSec}s)`,
      });
    }

    const threshold = this.configService.get<number>('VIDEO_COMPLETION_THRESHOLD', 0.9);
    const isCompleted = dto.positionSec / video.durationSec >= threshold;

    let pointsAwarded = false;

    await this.prisma.$transaction(async (tx) => {
      // 1. Upsert VideoProgress
      const existing = await tx.videoProgress.findUnique({
        where: { userId_videoId: { userId, videoId } },
      });

      const wasAlreadyCompleted = existing?.completed || false;
      const willBeCompleted = wasAlreadyCompleted || isCompleted;

      await tx.videoProgress.upsert({
        where: { userId_videoId: { userId, videoId } },
        update: {
          lastPositionSec: dto.positionSec,
          completed: willBeCompleted,
          completedAt: willBeCompleted && !wasAlreadyCompleted ? new Date() : undefined,
        },
        create: {
          userId,
          videoId,
          lastPositionSec: dto.positionSec,
          completed: willBeCompleted,
          completedAt: willBeCompleted ? new Date() : null,
        },
      });

      // 2. Award points once if newly completed
      if (willBeCompleted && !wasAlreadyCompleted) {
        const refEventId = `video_${videoId}_user_${userId}`;
        try {
          await tx.confyPointsLedger.create({
            data: {
              userId,
              delta: 15,
              reason: `Completed video: ${video.title}`,
              refEventId,
            },
          });
          pointsAwarded = true;
        } catch {
          // Unique refEventId prevents duplicate points
        }

        // 3. Update TopicProgress
        await tx.topicProgress.upsert({
          where: { userId_topicId: { userId, topicId: video.topicId } },
          update: {
            videosCompleted: { increment: 1 },
            percentComplete: { increment: 20 },
          },
          create: {
            userId,
            topicId: video.topicId,
            videosCompleted: 1,
            percentComplete: 20,
          },
        });
      }
    });

    return {
      videoId,
      lastPositionSec: dto.positionSec,
      completed: isCompleted,
      pointsAwarded,
    };
  }
}

