import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { UpdateProfileDto } from './me.dto';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { ErrorCode } from '../../common/dto/error.dto';

@Injectable()
export class MeService {
  constructor(private readonly prisma: PrismaService) {}

  async getProfile(user?: AuthenticatedUser) {
    if (!user || user.isGuest) {
      return {
        isGuest: true,
        guestRef: user?.guestRef,
        prompt: 'Sign in to access your full profile, progress reports, and settings.',
      };
    }

    const userRecord = await this.prisma.user.findUnique({
      where: { id: user.id },
      include: { profile: true },
    });

    if (!userRecord) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'User profile not found',
      });
    }

    const totalPoints = await this.calculateConfyPoints(user.id);
    const level = await this.resolveConfyLevel(totalPoints);

    return {
      id: userRecord.id,
      email: userRecord.email,
      role: userRecord.role,
      status: userRecord.status,
      profile: userRecord.profile,
      confy: {
        points: totalPoints,
        level,
      },
    };
  }

  async getHistory(userId: string) {
    const topicProgress = await this.prisma.topicProgress.findMany({
      where: { userId },
      include: { topic: true },
    });

    const videoProgress = await this.prisma.videoProgress.findMany({
      where: { userId },
      include: { video: true },
    });

    const attempts = await this.prisma.assessmentAttempt.findMany({
      where: { userId },
      include: { assessment: true },
      orderBy: { startedAt: 'desc' },
      take: 10,
    });

    const recentEvents = await this.prisma.activityEvent.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 20,
    });

    return {
      topicProgress: topicProgress.map((tp) => ({
        topicId: tp.topicId,
        title: tp.topic.title,
        percentComplete: tp.percentComplete,
        quickTipsViewed: tp.quickTipsViewed,
        videosCompleted: tp.videosCompleted,
        assessmentsDone: tp.assessmentsDone,
      })),
      videoProgress: videoProgress.map((vp) => ({
        videoId: vp.videoId,
        title: vp.video.title,
        lastPositionSec: vp.lastPositionSec,
        completed: vp.completed,
      })),
      attempts: attempts.map((a) => ({
        id: a.id,
        assessmentTitle: a.assessment.title,
        score: a.score,
        status: a.status,
        submittedAt: a.submittedAt,
      })),
      recentActivity: recentEvents,
    };
  }

  async getProgress(userId: string) {
    const totalPoints = await this.calculateConfyPoints(userId);
    const level = await this.resolveConfyLevel(totalPoints);

    const ledger = await this.prisma.confyPointsLedger.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 15,
    });

    return {
      totalPoints,
      level,
      history: ledger,
    };
  }

  async updateProfile(userId: string, dto: UpdateProfileDto) {
    const profile = await this.prisma.profile.upsert({
      where: { userId },
      update: {
        name: dto.name,
        avatarUrl: dto.avatarUrl,
        notificationConsentEmail: dto.notificationConsentEmail,
        notificationConsentWhatsapp: dto.notificationConsentWhatsapp,
        optOutEmail: dto.optOutEmail,
        optOutWhatsapp: dto.optOutWhatsapp,
      },
      create: {
        userId,
        name: dto.name || 'User',
        avatarUrl: dto.avatarUrl,
        notificationConsentEmail: dto.notificationConsentEmail ?? true,
        notificationConsentWhatsapp: dto.notificationConsentWhatsapp ?? false,
        optOutEmail: dto.optOutEmail ?? false,
        optOutWhatsapp: dto.optOutWhatsapp ?? false,
      },
    });

    return profile;
  }

  private async calculateConfyPoints(userId: string): Promise<number> {
    const ledger = await this.prisma.confyPointsLedger.findMany({
      where: { userId },
      select: { delta: true },
    });
    return ledger.reduce((acc, curr) => acc + curr.delta, 0);
  }

  private async resolveConfyLevel(points: number) {
    const levels = await this.prisma.confyLevel.findMany({
      orderBy: { order: 'asc' },
    });

    let current = levels[0];
    for (const lvl of levels) {
      if (points >= lvl.minPoints) {
        current = lvl;
      }
    }

    return current ? {
      name: current.name,
      minPoints: current.minPoints,
      maxPoints: current.maxPoints,
      quickActions: current.quickActionsConfig,
    } : null;
  }
}

