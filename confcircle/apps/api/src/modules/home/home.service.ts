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
    // Spec v3.0: Level 4 question prompts are the ONLY user-facing discovery items.
    // 7–8 randomly selected, published, guest-eligible Level 4 questions.
    const l4Questions = await (this.prisma as any).questionPrompt?.findMany({
      where: {
        publishStatus: 'published',
        guestEligible: true,
      },
      take: 8,
    });

    const fallbackQuestions = [
      { id: 'q1', prompt: 'How do I stop overthinking in group meetings and actually speak up?', shortDescription: 'Quick tactics for clarity' },
      { id: 'q2', prompt: 'What can I do when imposter syndrome kicks in before a presentation?', shortDescription: 'Mental grounding tools' },
      { id: 'q3', prompt: 'How do I make tough decisions without constantly second-guessing myself?', shortDescription: 'Decisive action framework' },
      { id: 'q4', prompt: 'How can I stop comparing my career journey to my peers on social media?', shortDescription: 'Self-worth and focus' },
      { id: 'q5', prompt: 'How do I set firm boundaries with friends without feeling guilty?', shortDescription: 'Mindset shifts and boundary scripts' },
      { id: 'q6', prompt: 'How should I answer "Tell me about a time you failed" in an interview?', shortDescription: 'Resilience and storytelling' },
      { id: 'q7', prompt: 'What is a 2-minute daily routine to reset when stress feels overwhelming?', shortDescription: 'Nervous system reset' },
      { id: 'q8', prompt: 'How can I retain what I study without having to re-read everything twice?', shortDescription: 'Active recall strategies' },
    ];

    const discoveryQuestions = l4Questions && l4Questions.length > 0
      ? l4Questions.map((q: any) => ({
          questionId: q.id,
          prompt: q.promptText,
          shortDescription: q.shortDescription,
          displayAsset: q.displayAsset,
        }))
      : fallbackQuestions.map((q) => ({
          questionId: q.id,
          prompt: q.prompt,
          shortDescription: q.shortDescription,
          displayAsset: null,
        }));

    return {
      role: 'guest',
      guestRef,
      greeting: 'Welcome to ConfCircle!',
      subGreeting: 'Explore real-world challenges and build your confidence.',
      isRegistered: false,
      discoveryQuestions, // 7-8 Level 4 questions only
      quickActions: [
        { id: 'guest_questions', title: 'Daily Discovery Questions', type: 'questions', enabled: true },
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

    // Spec v3.0: 5–6 randomly selected, published, eligible Level 4 questions.
    const l4Questions = await (this.prisma as any).questionPrompt?.findMany({
      where: {
        publishStatus: 'published',
        registeredEligible: true,
      },
      take: 6,
    });

    const fallbackQuestions = [
      { id: 'rq1', prompt: 'How do I handle an awkward silence in a 1-on-1 conversation?', shortDescription: 'Natural follow-up prompts' },
      { id: 'rq2', prompt: 'What should I do right after making a visible mistake at work or college?', shortDescription: 'Own it and rebuild trust' },
      { id: 'rq3', prompt: 'How do I ask senior leaders for guidance without feeling like a burden?', shortDescription: 'High-impact mentorship requests' },
      { id: 'rq4', prompt: 'How can I stay calm and articulate under unexpected questioning?', shortDescription: 'Pause-Acknowledge-Answer' },
      { id: 'rq5', prompt: 'How do I stop overthinking in group meetings and actually speak up?', shortDescription: 'Quick tactics for speaking up' },
      { id: 'rq6', prompt: 'What can I do when imposter syndrome kicks in before a presentation?', shortDescription: 'Grounding techniques' },
    ];

    const discoveryQuestions = l4Questions && l4Questions.length > 0
      ? l4Questions.map((q: any) => ({
          questionId: q.id,
          prompt: q.promptText,
          shortDescription: q.shortDescription,
          displayAsset: q.displayAsset,
        }))
      : fallbackQuestions.map((q) => ({
          questionId: q.id,
          prompt: q.prompt,
          shortDescription: q.shortDescription,
          displayAsset: null,
        }));

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
      discoveryQuestions, // 5-6 Level 4 questions only (Spec v3.0)
      enrolledCourse: user?.enrolments?.[0] ? {
        id: user.enrolments[0].course.id,
        title: user.enrolments[0].course.title,
        enrolledAt: user.enrolments[0].enrolledAt,
      } : null,
      quickActions: [
        { id: 'quick_tips', title: 'Quick Tips', type: 'quicktip', enabled: true },
        { id: 'video_solutions', title: 'Video Solutions', type: 'video', enabled: true },
        { id: 'assessments', title: 'Assessments', type: 'assessment', enabled: true },
        { id: 'circle_community', title: 'Circle Community', type: 'circle', enabled: true },
      ],
    };
  }
}

