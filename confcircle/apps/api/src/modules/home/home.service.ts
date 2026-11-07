import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';

@Injectable()
export class HomeService {
  constructor(private readonly prisma: PrismaService) {}

  async getHomeDashboard(user?: AuthenticatedUser) {
    if (!user || user.isGuest) {
      return this.getGuestDashboard(user?.guestRef);
    }
    return this.getRegisteredDashboard(user.id);
  }

  private async getGuestDashboard(guestRef?: string) {
    const featuredTopics = await this.prisma.topic.findMany({
      where: { published: true },
      take: 4,
      orderBy: { order: 'asc' },
      include: {
        category: true,
        level: true,
      },
    });

    return {
      role: 'guest',
      guestRef,
      greeting: 'Welcome to ConfCircle!',
      subGreeting: 'Explore foundational skills and boost your confidence.',
      isRegistered: false,
      recommendedTopics: featuredTopics.map((t) => ({
        id: t.id,
        title: t.title,
        category: t.category.name,
        level: t.level.name,
      })),
      quickActions: [
        { id: 'guest_questions', title: 'Daily Questions', type: 'questions', enabled: true },
        { id: 'quick_tips', title: 'Quick Tips', type: 'quicktip', enabled: true },
        { id: 'video_preview', title: 'Video Solutions', type: 'video', enabled: false, reason: 'ACCOUNT_REQUIRED' },
        { id: 'assessments', title: 'Assessments', type: 'assessment', enabled: false, reason: 'ACCOUNT_REQUIRED' },
      ],
      prompts: {
        signUpCta: 'Create a free account to unlock video solutions, assessments, and track your Confy Level!',
      },
    };
  }

  private async getRegisteredDashboard(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: {
        profile: true,
        confyPoints: true,
        topicProgress: { include: { topic: true } },
        enrolments: { include: { course: true }, take: 1 },
      },
    });

    // Compute Confy Points from ledger
    const totalPoints = (user?.confyPoints || []).reduce((acc, curr) => acc + curr.delta, 0);

    // Resolve Confy Level
    const confyLevels = await this.prisma.confyLevel.findMany({
      orderBy: { order: 'asc' },
    });
    let currentLevel = confyLevels[0];
    for (const lvl of confyLevels) {
      if (totalPoints >= lvl.minPoints) {
        currentLevel = lvl;
      }
    }

    const topics = await this.prisma.topic.findMany({
      where: { published: true },
      take: 6,
      orderBy: { order: 'asc' },
      include: { category: true, level: true },
    });

    return {
      role: 'registered',
      isRegistered: true,
      profile: {
        id: user?.id,
        name: user?.profile?.name || 'Explorer',
        avatarUrl: user?.profile?.avatarUrl,
      },
      confy: {
        points: totalPoints,
        level: currentLevel ? {
          id: currentLevel.id,
          name: currentLevel.name,
          minPoints: currentLevel.minPoints,
          maxPoints: currentLevel.maxPoints,
          quickActions: currentLevel.quickActionsConfig,
        } : null,
      },
      recentProgress: (user?.topicProgress || []).map((tp) => ({
        topicId: tp.topicId,
        topicTitle: tp.topic.title,
        percentComplete: tp.percentComplete,
      })),
      enrolledCourse: user?.enrolments?.[0] ? {
        id: user.enrolments[0].course.id,
        title: user.enrolments[0].course.title,
        enrolledAt: user.enrolments[0].enrolledAt,
      } : null,
      recommendedTopics: topics.map((t) => ({
        id: t.id,
        title: t.title,
        category: t.category.name,
        level: t.level.name,
      })),
      quickActions: [
        { id: 'quick_tips', title: 'Quick Tips', type: 'quicktip', enabled: true },
        { id: 'video_solutions', title: 'Video Solutions', type: 'video', enabled: true },
        { id: 'assessments', title: 'Assessments', type: 'assessment', enabled: true },
        { id: 'circle_community', title: 'Circle Community', type: 'circle', enabled: true },
      ],
    };
  }
}

