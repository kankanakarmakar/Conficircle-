import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { ErrorCode } from '../../common/dto/error.dto';

@Injectable()
export class TopicsService {
  constructor(private readonly prisma: PrismaService) {}

  async getTopics(categoryId?: string, levelId?: string, user?: AuthenticatedUser) {
    const where: any = { published: true };
    if (categoryId) where.categoryId = categoryId;
    if (levelId) where.levelId = levelId;

    const topics = await this.prisma.topic.findMany({
      where,
      orderBy: { order: 'asc' },
      include: {
        category: true,
        level: true,
        _count: {
          select: { quickTips: true, videoSolutions: true, assessments: true },
        },
      },
    });

    let progressMap: Record<string, number> = {};
    if (user && !user.isGuest) {
      const progresses = await this.prisma.topicProgress.findMany({
        where: { userId: user.id },
      });
      for (const p of progresses) {
        progressMap[p.topicId] = p.percentComplete;
      }
    }

    return topics.map((t) => ({
      id: t.id,
      title: t.title,
      slug: t.slug,
      category: t.category.name,
      level: t.level.name,
      counts: {
        quickTips: t._count.quickTips,
        videos: t._count.videoSolutions,
        assessments: t._count.assessments,
      },
      percentComplete: progressMap[t.id] ?? 0,
    }));
  }

  async getTopicDetail(id: string, user?: AuthenticatedUser) {
    const topic = await this.prisma.topic.findUnique({
      where: { id },
      include: {
        category: true,
        level: true,
        quickTips: { where: { published: true }, select: { id: true, content: true, order: true } },
        videoSolutions: { where: { published: true }, select: { id: true, title: true, durationSec: true } },
        assessments: { where: { published: true }, select: { id: true, title: true, timerSec: true } },
      },
    });

    if (!topic) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Topic not found',
      });
    }

    const isGuest = !user || user.isGuest;

    // Backend-driven action availability
    const actions = [
      {
        type: 'quicktip',
        title: 'Quick Tips',
        count: topic.quickTips.length,
        enabled: true,
        items: topic.quickTips,
      },
      {
        type: 'video',
        title: 'Video Solutions',
        count: topic.videoSolutions.length,
        enabled: !isGuest,
        reason: isGuest ? 'ACCOUNT_REQUIRED' : undefined,
        items: isGuest ? [] : topic.videoSolutions,
      },
      {
        type: 'assessment',
        title: 'Quick Assessment',
        count: topic.assessments.length,
        enabled: !isGuest,
        reason: isGuest ? 'ACCOUNT_REQUIRED' : undefined,
        items: isGuest ? [] : topic.assessments,
      },
    ];

    let userProgress = 0;
    if (!isGuest) {
      const progress = await this.prisma.topicProgress.findUnique({
        where: { userId_topicId: { userId: user.id, topicId: id } },
      });
      userProgress = progress?.percentComplete ?? 0;
    }

    return {
      id: topic.id,
      title: topic.title,
      slug: topic.slug,
      category: topic.category.name,
      level: topic.level.name,
      percentComplete: userProgress,
      actions,
    };
  }

  async getTopicContent(id: string, user?: AuthenticatedUser) {
    const topic = await this.prisma.topic.findUnique({
      where: { id },
      include: {
        quickTips: { where: { published: true } },
        videoSolutions: { where: { published: true } },
      },
    });

    if (!topic) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Topic not found',
      });
    }

    const isGuest = !user || user.isGuest;

    return {
      topicId: topic.id,
      title: topic.title,
      quickTips: topic.quickTips.map((qt) => ({
        id: qt.id,
        content: qt.content,
        order: qt.order,
      })),
      videoSolutions: isGuest
        ? []
        : topic.videoSolutions.map((vs) => ({
            id: vs.id,
            title: vs.title,
            durationSec: vs.durationSec,
            metadata: vs.metadata,
          })),
    };
  }
}

