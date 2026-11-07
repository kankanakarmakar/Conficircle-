import { PrismaClient } from '@prisma/client';
import { v4 as uuidv4 } from 'uuid';
import * as argon2 from 'argon2';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting seed...');

  // ─────────────────────────────────────────────
  // AppConfig
  // ─────────────────────────────────────────────
  console.log('  → AppConfig');
  const appConfigs = [
    { key: 'GUEST_TTL_SECONDS', value: 3600, description: 'Guest session TTL in seconds' },
    { key: 'GUEST_QUICKTIP_QUOTA', value: 3, description: 'Max quicktips a guest can open per session' },
    { key: 'VIDEO_COMPLETION_THRESHOLD', value: 0.9, description: 'Fraction of video watched to count as complete' },
    { key: 'GUEST_QUESTION_COUNT', value: 3, description: 'Number of questions shown to guest per session' },
    { key: 'CONFY_POINTS_QUICKTIP_VIEW', value: 5, description: 'Points for viewing a quicktip' },
    { key: 'CONFY_POINTS_VIDEO_COMPLETE', value: 20, description: 'Points for completing a video' },
    { key: 'CONFY_POINTS_ASSESSMENT_PASS', value: 50, description: 'Points for passing an assessment' },
  ];

  for (const cfg of appConfigs) {
    await prisma.appConfig.upsert({
      where: { key: cfg.key },
      update: { value: cfg.value, description: cfg.description },
      create: { key: cfg.key, value: cfg.value, description: cfg.description },
    });
  }

  // ─────────────────────────────────────────────
  // FeatureFlags
  // ─────────────────────────────────────────────
  console.log('  → FeatureFlags');
  const flags = [
    { key: 'guest_session_enabled', enabled: true, description: 'Allow anonymous guest sessions' },
    { key: 'circle_posting_enabled', enabled: true, description: 'Allow users to create posts in circles' },
    { key: 'whatsapp_notifications_enabled', enabled: false, description: 'Send notifications via WhatsApp' },
    { key: 'course_enrolment_enabled', enabled: true, description: 'Allow users to enrol in courses' },
    { key: 'confy_points_enabled', enabled: true, description: 'Enable Confy gamification points system' },
    { key: 'ai_recommendations_enabled', enabled: false, description: 'AI-based topic recommendations' },
  ];

  for (const flag of flags) {
    await prisma.featureFlag.upsert({
      where: { key: flag.key },
      update: { enabled: flag.enabled, description: flag.description },
      create: { key: flag.key, enabled: flag.enabled, description: flag.description },
    });
  }

  // ─────────────────────────────────────────────
  // Levels
  // ─────────────────────────────────────────────
  console.log('  → Levels');
  const levels = await Promise.all([
    prisma.level.upsert({
      where: { name: 'Beginner' },
      update: {},
      create: { name: 'Beginner', order: 1, description: 'Foundation concepts for building confidence' },
    }),
    prisma.level.upsert({
      where: { name: 'Intermediate' },
      update: {},
      create: { name: 'Intermediate', order: 2, description: 'Developing skills and techniques' },
    }),
    prisma.level.upsert({
      where: { name: 'Advanced' },
      update: {},
      create: { name: 'Advanced', order: 3, description: 'Mastery and high-performance strategies' },
    }),
    prisma.level.upsert({
      where: { name: 'Assessment' },
      update: {},
      create: { name: 'Assessment', order: 4, description: 'Level used for guest assessment questions' },
    }),
  ]);
  const [beginner, intermediate, advanced, assessmentLevel] = levels;

  // ─────────────────────────────────────────────
  // Categories
  // ─────────────────────────────────────────────
  console.log('  → Categories');
  const [catConfidence, catCommunication, catLeadership] = await Promise.all([
    prisma.category.upsert({
      where: { slug: 'confidence' },
      update: {},
      create: { name: 'Confidence', slug: 'confidence', order: 1 },
    }),
    prisma.category.upsert({
      where: { slug: 'communication' },
      update: {},
      create: { name: 'Communication', slug: 'communication', order: 2 },
    }),
    prisma.category.upsert({
      where: { slug: 'leadership' },
      update: {},
      create: { name: 'Leadership', slug: 'leadership', order: 3 },
    }),
  ]);

  // ─────────────────────────────────────────────
  // Topics (10 total)
  // ─────────────────────────────────────────────
  console.log('  → Topics');
  const topicData = [
    { title: 'Overcoming Self-Doubt', slug: 'overcoming-self-doubt', categoryId: catConfidence.id, levelId: beginner.id, order: 1 },
    { title: 'Building Inner Strength', slug: 'building-inner-strength', categoryId: catConfidence.id, levelId: intermediate.id, order: 2 },
    { title: 'Assertive Confidence', slug: 'assertive-confidence', categoryId: catConfidence.id, levelId: advanced.id, order: 3 },
    { title: 'Active Listening Skills', slug: 'active-listening-skills', categoryId: catCommunication.id, levelId: beginner.id, order: 1 },
    { title: 'Effective Public Speaking', slug: 'effective-public-speaking', categoryId: catCommunication.id, levelId: intermediate.id, order: 2 },
    { title: 'Difficult Conversations', slug: 'difficult-conversations', categoryId: catCommunication.id, levelId: advanced.id, order: 3 },
    { title: 'Understanding Leadership Styles', slug: 'understanding-leadership-styles', categoryId: catLeadership.id, levelId: beginner.id, order: 1 },
    { title: 'Team Motivation Techniques', slug: 'team-motivation-techniques', categoryId: catLeadership.id, levelId: intermediate.id, order: 2 },
    { title: 'Strategic Decision Making', slug: 'strategic-decision-making', categoryId: catLeadership.id, levelId: advanced.id, order: 3 },
    { title: 'Conflict Resolution', slug: 'conflict-resolution', categoryId: catLeadership.id, levelId: intermediate.id, order: 4 },
  ];

  const topics = [];
  for (const t of topicData) {
    const topic = await prisma.topic.upsert({
      where: { slug: t.slug },
      update: {},
      create: { ...t, published: true },
    });
    topics.push(topic);
  }

  // ─────────────────────────────────────────────
  // QuickTips (5 per topic)
  // ─────────────────────────────────────────────
  console.log('  → QuickTips');
  const quickTipTemplates: Record<string, string[]> = {
    'overcoming-self-doubt': [
      'Start each morning by writing down three things you did well yesterday.',
      'Challenge your inner critic by asking "Is this thought factually true?"',
      'Set micro-goals that build momentum — small wins rewire your confidence neural pathways.',
      'Surround yourself with people who believe in you during vulnerable growth periods.',
      'Use power posing for 2 minutes before high-stakes moments to shift your physiology.',
    ],
    'building-inner-strength': [
      'Develop a daily resilience ritual: reflect, reframe, and recommit each evening.',
      'Practice emotional regulation by naming your feelings before reacting to them.',
      'Build your personal value system to have a compass during uncertain times.',
      'Seek discomfort intentionally — growth lives at the edge of your comfort zone.',
      'Journaling your setbacks alongside your responses builds a track record of recovery.',
    ],
    'assertive-confidence': [
      'Use "I" statements to express your needs without sounding aggressive.',
      'Practice saying "no" to small requests first to build your assertiveness muscle.',
      'Maintain eye contact and an open posture to signal confidence non-verbally.',
      'Pause before responding — silence communicates composure, not weakness.',
      'Acknowledge others\' views before asserting your own: "I hear you, and here\'s my perspective..."',
    ],
    'active-listening-skills': [
      'Put your phone face-down during conversations to signal full presence.',
      'Paraphrase what you heard before responding: "So what I\'m hearing is..."',
      'Ask open-ended follow-up questions to deepen understanding.',
      'Notice the emotion behind the words, not just the content.',
      'Avoid planning your reply while the other person is still speaking.',
    ],
    'effective-public-speaking': [
      'Know your first 30 seconds by heart — confidence at the start sets the tone.',
      'Speak to one person at a time in the audience; rotate your eye contact deliberately.',
      'Slow down when making key points; speed signals nervousness.',
      'Use the rule of three: group ideas in threes for maximum retention.',
      'Rehearse out loud, not just in your head — your mouth and brain are different muscles.',
    ],
    'difficult-conversations': [
      'Choose the right time and place — never have a difficult conversation when either party is rushed.',
      'Lead with curiosity, not accusation: "Help me understand..."',
      'Separate the person from the problem; attack the issue, not the individual.',
      'Agree on a shared goal at the start: "We both want this project to succeed."',
      'If emotions escalate, call a time-out and resume when calm.',
    ],
    'understanding-leadership-styles': [
      'Identify your natural leadership style using a simple self-assessment today.',
      'Situational leadership means adapting your style to the team member\'s readiness level.',
      'Transformational leaders inspire through vision; transactional leaders motivate through rewards — both have their place.',
      'Ask your team how they prefer to be led — their answer may surprise you.',
      'The best leaders build more leaders, not more followers.',
    ],
    'team-motivation-techniques': [
      'Recognise effort publicly, correct privately — public praise builds team culture.',
      'Connect daily tasks to the bigger mission; people work harder when they see the "why".',
      'Create psychological safety so team members take creative risks without fear.',
      'Give autonomy over "how" while aligning on "what" — it dramatically boosts ownership.',
      'Regular one-on-ones are the single highest-ROI leadership activity available.',
    ],
    'strategic-decision-making': [
      'Use the 10-10-10 rule: how will you feel about this in 10 minutes, 10 months, 10 years?',
      'Distinguish between reversible and irreversible decisions — most are reversible.',
      'Seek disconfirming evidence before committing to a decision.',
      'Define your decision criteria before reviewing the options to avoid post-hoc rationalisation.',
      'Write down your decision and reasoning — it activates your analytical brain.',
    ],
    'conflict-resolution': [
      'Acknowledge the conflict early — unaddressed friction compounds.',
      'Focus on interests (why they want it), not positions (what they want).',
      'Look for a BATNA (Best Alternative to Negotiated Agreement) before entering negotiation.',
      'Use active listening to demonstrate you value their perspective before proposing solutions.',
      'Document agreements clearly: who does what, by when — prevents future misunderstandings.',
    ],
  };

  for (const topic of topics) {
    const tips = quickTipTemplates[topic.slug] ?? [];
    for (let i = 0; i < tips.length; i++) {
      const existing = await prisma.quickTip.findFirst({ where: { topicId: topic.id, order: i } });
      if (!existing) {
        await prisma.quickTip.create({
          data: { topicId: topic.id, content: tips[i], order: i, published: true },
        });
      }
    }
  }

  // ─────────────────────────────────────────────
  // VideoSolutions (2 per topic)
  // ─────────────────────────────────────────────
  console.log('  → VideoSolutions');
  for (const topic of topics) {
    const existing = await prisma.videoSolution.count({ where: { topicId: topic.id } });
    if (existing === 0) {
      await prisma.videoSolution.createMany({
        data: [
          {
            topicId: topic.id,
            title: `Introduction to ${topic.title}`,
            storageKey: `videos/${topic.slug}/intro.mp4`,
            durationSec: 480,
            metadata: { resolution: '1080p', format: 'mp4', thumbnailKey: `thumbnails/${topic.slug}/intro.jpg` },
            published: true,
          },
          {
            topicId: topic.id,
            title: `Deep Dive: ${topic.title}`,
            storageKey: `videos/${topic.slug}/deep-dive.mp4`,
            durationSec: 900,
            metadata: { resolution: '1080p', format: 'mp4', thumbnailKey: `thumbnails/${topic.slug}/deep-dive.jpg` },
            published: true,
          },
        ],
      });
    }
  }

  // ─────────────────────────────────────────────
  // Questions (10 guest-eligible, assessmentLevel)
  // ─────────────────────────────────────────────
  console.log('  → Questions');
  const guestQuestionData = [
    'Which of the following best describes self-efficacy?',
    'What is the primary purpose of active listening?',
    'Which leadership style focuses on inspiring a shared vision?',
    'What does assertive communication involve?',
    'Which technique helps manage public speaking anxiety?',
    'What is the first step in resolving workplace conflict?',
    'What does "psychological safety" mean in a team context?',
    'Which approach is most effective for making strategic decisions?',
    'What characterises a growth mindset?',
    'What is a BATNA in negotiation?',
  ];

  const guestQuestions = [];
  for (const content of guestQuestionData) {
    const existing = await prisma.question.findFirst({ where: { content, levelId: assessmentLevel.id } });
    if (existing) {
      guestQuestions.push(existing);
    } else {
      const q = await prisma.question.create({
        data: { levelId: assessmentLevel.id, content, eligibleForGuest: true, active: true },
      });
      guestQuestions.push(q);
    }
  }

  // Options for guest questions
  const guestQuestionOptions: Record<number, { content: string; isCorrect: boolean }[]> = {
    0: [
      { content: 'Believing in one\'s ability to succeed in specific situations', isCorrect: true },
      { content: 'Feeling superior to others in a social setting', isCorrect: false },
      { content: 'Avoiding challenges to protect one\'s self-image', isCorrect: false },
      { content: 'Relying on external praise to feel capable', isCorrect: false },
    ],
    1: [
      { content: 'To fully understand what the speaker is communicating', isCorrect: true },
      { content: 'To prepare your counter-argument while the other person speaks', isCorrect: false },
      { content: 'To demonstrate your superior knowledge', isCorrect: false },
      { content: 'To speed up conversations', isCorrect: false },
    ],
    2: [
      { content: 'Transformational leadership', isCorrect: true },
      { content: 'Transactional leadership', isCorrect: false },
      { content: 'Laissez-faire leadership', isCorrect: false },
      { content: 'Autocratic leadership', isCorrect: false },
    ],
    3: [
      { content: 'Expressing needs clearly while respecting others\' boundaries', isCorrect: true },
      { content: 'Dominating the conversation to get what you want', isCorrect: false },
      { content: 'Avoiding conflict at all costs', isCorrect: false },
      { content: 'Agreeing with others to maintain harmony', isCorrect: false },
    ],
    4: [
      { content: 'Thorough preparation and rehearsal', isCorrect: true },
      { content: 'Speaking as fast as possible', isCorrect: false },
      { content: 'Memorising the entire script word-for-word', isCorrect: false },
      { content: 'Avoiding eye contact with the audience', isCorrect: false },
    ],
    5: [
      { content: 'Acknowledge the conflict and understand each party\'s perspective', isCorrect: true },
      { content: 'Immediately escalate to management', isCorrect: false },
      { content: 'Ignore it and hope it resolves itself', isCorrect: false },
      { content: 'Side with the person who has seniority', isCorrect: false },
    ],
    6: [
      { content: 'Team members feel safe to take risks without fear of punishment', isCorrect: true },
      { content: 'The office has strict security protocols', isCorrect: false },
      { content: 'Employees are protected from redundancy', isCorrect: false },
      { content: 'All team decisions require consensus', isCorrect: false },
    ],
    7: [
      { content: 'Defining decision criteria before reviewing options', isCorrect: true },
      { content: 'Going with your gut instinct every time', isCorrect: false },
      { content: 'Always choosing the option with the lowest risk', isCorrect: false },
      { content: 'Delegating all decisions to subject-matter experts', isCorrect: false },
    ],
    8: [
      { content: 'Believing abilities can be developed through dedication and effort', isCorrect: true },
      { content: 'Believing intelligence is fixed at birth', isCorrect: false },
      { content: 'Focusing only on tasks you already excel at', isCorrect: false },
      { content: 'Avoiding feedback to protect your confidence', isCorrect: false },
    ],
    9: [
      { content: 'The best alternative course of action if negotiations fail', isCorrect: true },
      { content: 'A binding legal agreement between two parties', isCorrect: false },
      { content: 'The maximum concession you are willing to make', isCorrect: false },
      { content: 'A mediator appointed by both parties', isCorrect: false },
    ],
  };

  for (let i = 0; i < guestQuestions.length; i++) {
    const q = guestQuestions[i];
    const existing = await prisma.assessmentOption.count({ where: { questionId: q.id } });
    if (existing === 0) {
      await prisma.assessmentOption.createMany({
        data: (guestQuestionOptions[i] ?? []).map((opt) => ({ questionId: q.id, ...opt })),
      });
    }
  }

  // ─────────────────────────────────────────────
  // Topic Questions + Assessments (1 per topic, 5 questions each)
  // ─────────────────────────────────────────────
  console.log('  → Assessments & Topic Questions');
  for (const topic of topics) {
    // Create 5 topic-specific questions
    const topicQuestionsData = [
      `What is a key principle of "${topic.title}"?`,
      `Which technique is most effective when practising "${topic.title}"?`,
      `What is a common mistake people make related to "${topic.title}"?`,
      `How can "${topic.title}" improve professional relationships?`,
      `Which mindset best supports development in "${topic.title}"?`,
    ];

    const topicQuestions = [];
    for (const content of topicQuestionsData) {
      const existing = await prisma.question.findFirst({ where: { content, topicId: topic.id } });
      if (existing) {
        topicQuestions.push(existing);
      } else {
        const q = await prisma.question.create({
          data: { levelId: topic.levelId, topicId: topic.id, content, eligibleForGuest: false, active: true },
        });
        topicQuestions.push(q);
      }
    }

    // Create options for each topic question
    for (const q of topicQuestions) {
      const existing = await prisma.assessmentOption.count({ where: { questionId: q.id } });
      if (existing === 0) {
        await prisma.assessmentOption.createMany({
          data: [
            { questionId: q.id, content: 'The correct answer demonstrating mastery of this topic', isCorrect: true },
            { questionId: q.id, content: 'A plausible but incorrect distractor option', isCorrect: false },
            { questionId: q.id, content: 'Another incorrect option that tests understanding', isCorrect: false },
            { questionId: q.id, content: 'A common misconception about this topic', isCorrect: false },
          ],
        });
      }
    }

    // Create assessment
    const existingAssessment = await prisma.assessment.findFirst({ where: { topicId: topic.id } });
    let assessment = existingAssessment;
    if (!assessment) {
      assessment = await prisma.assessment.create({
        data: {
          topicId: topic.id,
          title: `${topic.title} Assessment`,
          timerSec: 300,
          maxAttempts: 3,
          scoringRules: { passMark: 60, pointsForPass: 50, pointsPerCorrect: 10 },
          published: true,
        },
      });
    }

    // Link questions to assessment
    for (let i = 0; i < topicQuestions.length; i++) {
      await prisma.assessmentQuestion.upsert({
        where: { assessmentId_questionId: { assessmentId: assessment.id, questionId: topicQuestions[i].id } },
        update: {},
        create: { assessmentId: assessment.id, questionId: topicQuestions[i].id, order: i },
      });
    }
  }

  // ─────────────────────────────────────────────
  // ConfyLevels
  // ─────────────────────────────────────────────
  console.log('  → ConfyLevels');
  const confyLevels = [
    {
      name: 'Confidence Seedling',
      minPoints: 0,
      maxPoints: 199,
      order: 1,
      quickActionsConfig: [
        { action: 'view_quicktip', label: 'Read a Quick Tip', points: 5 },
        { action: 'complete_video', label: 'Watch a Video', points: 20 },
      ],
    },
    {
      name: 'Confidence Builder',
      minPoints: 200,
      maxPoints: 999,
      order: 2,
      quickActionsConfig: [
        { action: 'view_quicktip', label: 'Read a Quick Tip', points: 5 },
        { action: 'complete_video', label: 'Watch a Video', points: 20 },
        { action: 'pass_assessment', label: 'Pass an Assessment', points: 50 },
        { action: 'join_circle', label: 'Join a Circle Group', points: 15 },
      ],
    },
    {
      name: 'Confidence Champion',
      minPoints: 1000,
      maxPoints: null,
      order: 3,
      quickActionsConfig: [
        { action: 'view_quicktip', label: 'Read a Quick Tip', points: 5 },
        { action: 'complete_video', label: 'Watch a Video', points: 20 },
        { action: 'pass_assessment', label: 'Pass an Assessment', points: 50 },
        { action: 'join_circle', label: 'Join a Circle Group', points: 15 },
        { action: 'create_post', label: 'Share in a Circle', points: 10 },
      ],
    },
  ];

  for (const cl of confyLevels) {
    const existing = await prisma.confyLevel.findFirst({ where: { name: cl.name } });
    if (!existing) {
      await prisma.confyLevel.create({ data: cl });
    }
  }

  // ─────────────────────────────────────────────
  // Resources (5: 3 public, 2 registered_only)
  // ─────────────────────────────────────────────
  console.log('  → Resources');
  const resources = [
    {
      title: 'Confidence Building Workbook',
      category: 'workbook',
      tags: ['confidence', 'self-esteem', 'beginner'],
      status: 'published' as const,
      storageKey: 'resources/workbooks/confidence-building.pdf',
      accessRule: 'public' as const,
    },
    {
      title: 'Public Speaking Cheat Sheet',
      category: 'cheatsheet',
      tags: ['communication', 'public-speaking', 'quick-reference'],
      status: 'published' as const,
      storageKey: 'resources/cheatsheets/public-speaking.pdf',
      accessRule: 'public' as const,
    },
    {
      title: 'Leadership Styles Overview',
      category: 'guide',
      tags: ['leadership', 'management', 'overview'],
      status: 'published' as const,
      storageKey: 'resources/guides/leadership-styles.pdf',
      accessRule: 'public' as const,
    },
    {
      title: 'Advanced Conflict Resolution Toolkit',
      category: 'toolkit',
      tags: ['leadership', 'conflict', 'advanced', 'templates'],
      status: 'published' as const,
      storageKey: 'resources/toolkits/conflict-resolution.zip',
      accessRule: 'registered_only' as const,
    },
    {
      title: 'Personal Development Roadmap Template',
      category: 'template',
      tags: ['development', 'planning', 'career'],
      status: 'published' as const,
      storageKey: 'resources/templates/personal-development-roadmap.docx',
      accessRule: 'registered_only' as const,
    },
  ];

  for (const r of resources) {
    const existing = await prisma.resource.findFirst({ where: { storageKey: r.storageKey } });
    if (!existing) {
      await prisma.resource.create({ data: r });
    }
  }

  // ─────────────────────────────────────────────
  // CircleGroups (1 public, 1 private)
  // ─────────────────────────────────────────────
  console.log('  → CircleGroups');
  const groups = [
    {
      name: 'Confidence Builders Community',
      description: 'A welcoming space for anyone on their confidence journey. Share wins, ask questions, and grow together.',
      slug: 'confidence-builders',
      visibility: 'public' as const,
      moderationStatus: 'active' as const,
    },
    {
      name: 'Leadership Mastermind',
      description: 'An exclusive group for advanced learners and emerging leaders. By invitation or application only.',
      slug: 'leadership-mastermind',
      visibility: 'private' as const,
      moderationStatus: 'active' as const,
    },
  ];

  for (const g of groups) {
    await prisma.circleGroup.upsert({
      where: { slug: g.slug },
      update: {},
      create: g,
    });
  }

  // ─────────────────────────────────────────────
  // NotificationTemplates
  // ─────────────────────────────────────────────
  console.log('  → NotificationTemplates');
  const templates = [
    {
      name: 'welcome_email',
      channel: 'email' as const,
      subject: 'Welcome to ConfCircle — Your Confidence Journey Starts Now!',
      body: `Hi {{name}},

Welcome to ConfCircle! We're so glad you're here.

Your account is set up and ready. Here's what you can do next:
- Explore topics tailored to your confidence journey
- Watch expert video solutions
- Join circle groups and connect with others

Start your first topic: {{dashboard_url}}

With confidence,
The ConfCircle Team`,
    },
    {
      name: 'assessment_reminder_whatsapp',
      channel: 'whatsapp' as const,
      subject: null,
      body: `Hi {{name}} 👋

You started the *{{assessment_title}}* assessment but haven't finished yet.

You have {{attempts_remaining}} attempt(s) remaining. Complete it here: {{assessment_url}}

Keep going — you've got this! 💪`,
    },
    {
      name: 'weekly_progress_email',
      channel: 'email' as const,
      subject: 'Your Weekly ConfCircle Progress Update',
      body: `Hi {{name}},

Here's your progress this week:

📚 Topics explored: {{topics_count}}
🎥 Videos watched: {{videos_count}}
✅ Assessments completed: {{assessments_count}}
⭐ Confy Points earned: {{points_earned}}

Your current level: {{confy_level}}

Keep up the great work! Continue learning: {{dashboard_url}}

The ConfCircle Team`,
    },
  ];

  for (const t of templates) {
    await prisma.notificationTemplate.upsert({
      where: { name: t.name },
      update: {},
      create: t,
    });
  }

  // ─────────────────────────────────────────────
  // RecommendationConfig (Spec v3.0)
  // ─────────────────────────────────────────────
  console.log('  → RecommendationConfig (v3.0)');
  const existingConfig = await (prisma as any).recommendationConfig?.findFirst();
  if (!existingConfig && (prisma as any).recommendationConfig) {
    await (prisma as any).recommendationConfig.create({
      data: {
        guestBatchSize: 8,
        registeredBatchSize: 6,
        profileMatchWeight: 3.0,
        editorialBoostWeight: 2.0,
        freshnessBoostWeight: 1.0,
        explorationBonusWeight: 1.5,
        recentSeenPenaltyWeight: 2.5,
        dismissedPenaltyWeight: 5.0,
        historyWindowDays: 7,
      },
    });
  }

  // ─────────────────────────────────────────────
  // Taxonomy Hierarchy (L0 -> L1 -> L2 -> L3) & QuestionPrompts (L4)
  // ─────────────────────────────────────────────
  console.log('  → Taxonomy Nodes (L0-L3) & Question Prompts (L4)');
  if ((prisma as any).taxonomyNode) {
    // Level 0: Root
    let l0Root = await (prisma as any).taxonomyNode.findFirst({ where: { level: 0 } });
    if (!l0Root) {
      l0Root = await (prisma as any).taxonomyNode.create({
        data: {
          level: 0,
          internalName: 'ConfCircle Master Taxonomy Root',
          status: 'published',
        },
      });
    }

    // Level 1: Broad problem domains (FIXED)
    const l1Domains = [
      'Self Development & Confidence',
      'Communication & Expression',
      'Career & Higher Studies',
      'Wellbeing & Resilience',
      'Financial Clarity',
    ];

    const l1Nodes: Record<string, any> = {};
    for (const name of l1Domains) {
      let node = await (prisma as any).taxonomyNode.findFirst({
        where: { level: 1, internalName: name, parentId: l0Root.id },
      });
      if (!node) {
        node = await (prisma as any).taxonomyNode.create({
          data: {
            parentId: l0Root.id,
            level: 1,
            internalName: name,
            status: 'published',
          },
        });
      }
      l1Nodes[name] = node;
    }

    // Level 2: Problem subcategories (99% FIXED)
    const l2Definitions = [
      { name: 'Overthinking & Action Paralysis', parent: 'Self Development & Confidence' },
      { name: 'Self-Doubt & Imposter Feelings', parent: 'Self Development & Confidence' },
      { name: 'Public Speaking & Meeting Anxiety', parent: 'Communication & Expression' },
      { name: 'Assertiveness & Difficult Conversations', parent: 'Communication & Expression' },
      { name: 'Interview & Career Positioning', parent: 'Career & Higher Studies' },
      { name: 'Academic Direction & Study Strategy', parent: 'Career & Higher Studies' },
      { name: 'Stress, Burnout & Emotional Energy', parent: 'Wellbeing & Resilience' },
    ];

    const l2Nodes: Record<string, any> = {};
    for (const def of l2Definitions) {
      const parentNode = l1Nodes[def.parent];
      let node = await (prisma as any).taxonomyNode.findFirst({
        where: { level: 2, internalName: def.name, parentId: parentNode.id },
      });
      if (!node) {
        node = await (prisma as any).taxonomyNode.create({
          data: {
            parentId: parentNode.id,
            level: 2,
            internalName: def.name,
            status: 'published',
          },
        });
      }
      l2Nodes[def.name] = node;
    }

    // Level 3: Internal grouping & recommendation context (WILL EVOLVE)
    const l3Definitions = [
      { name: 'Meeting Participation Tactics', parent: 'Public Speaking & Meeting Anxiety' },
      { name: 'Presentation Confidence', parent: 'Public Speaking & Meeting Anxiety' },
      { name: 'Decisive Action Frameworks', parent: 'Overthinking & Action Paralysis' },
      { name: 'Self-Worth & Inner Compass', parent: 'Self-Doubt & Imposter Feelings' },
      { name: 'Boundary Setting & Saying No', parent: 'Assertiveness & Difficult Conversations' },
      { name: 'Job Interview Mastery', parent: 'Interview & Career Positioning' },
      { name: 'Daily Stress Reset Habits', parent: 'Stress, Burnout & Emotional Energy' },
      { name: 'Focused Study Systems', parent: 'Academic Direction & Study Strategy' },
    ];

    const l3Nodes: Record<string, any> = {};
    for (const def of l3Definitions) {
      const parentNode = l2Nodes[def.parent];
      let node = await (prisma as any).taxonomyNode.findFirst({
        where: { level: 3, internalName: def.name, parentId: parentNode.id },
      });
      if (!node) {
        node = await (prisma as any).taxonomyNode.create({
          data: {
            parentId: parentNode.id,
            level: 3,
            internalName: def.name,
            status: 'published',
          },
        });
      }
      l3Nodes[def.name] = node;
    }

    // Level 4: Question Prompts (WILL EVOLVE) - The ONLY consumer discovery cards
    const l4Questions = [
      {
        promptText: 'How do I stop overthinking in group meetings and actually speak up?',
        shortDescription: 'Quick tactics to contribute before hesitation takes over',
        l3Parent: 'Meeting Participation Tactics',
        guestEligible: true,
        registeredEligible: true,
      },
      {
        promptText: 'What can I do when imposter syndrome kicks in before a big presentation?',
        shortDescription: 'Mental grounding techniques to regain your calm',
        l3Parent: 'Presentation Confidence',
        guestEligible: true,
        registeredEligible: true,
      },
      {
        promptText: 'How do I make tough decisions without constantly second-guessing myself?',
        shortDescription: 'A practical framework to commit and move forward with conviction',
        l3Parent: 'Decisive Action Frameworks',
        guestEligible: true,
        registeredEligible: true,
      },
      {
        promptText: 'How can I stop comparing my career journey to my peers on social media?',
        shortDescription: 'Refocusing on your personal timeline and real strengths',
        l3Parent: 'Self-Worth & Inner Compass',
        guestEligible: true,
        registeredEligible: true,
      },
      {
        promptText: 'How do I set firm boundaries with friends or colleagues without feeling guilty?',
        shortDescription: 'Scripts and mindset shifts for saying no cleanly and kindly',
        l3Parent: 'Boundary Setting & Saying No',
        guestEligible: true,
        registeredEligible: true,
      },
      {
        promptText: 'How should I answer "Tell me about a time you failed" in an interview?',
        shortDescription: 'Turn a past mistake into a compelling story of resilience',
        l3Parent: 'Job Interview Mastery',
        guestEligible: true,
        registeredEligible: true,
      },
      {
        promptText: 'What is a 2-minute daily routine to reset when stress feels overwhelming?',
        shortDescription: 'Somatic breathing and nervous system calming tools',
        l3Parent: 'Daily Stress Reset Habits',
        guestEligible: true,
        registeredEligible: true,
      },
      {
        promptText: 'How can I retain what I study without having to re-read everything twice?',
        shortDescription: 'Active recall and spaced repetition in simple steps',
        l3Parent: 'Focused Study Systems',
        guestEligible: true,
        registeredEligible: true,
      },
      {
        promptText: 'How do I handle an awkward silence in a 1-on-1 conversation?',
        shortDescription: 'Natural follow-up prompts to keep conversations comfortable',
        l3Parent: 'Meeting Participation Tactics',
        guestEligible: true,
        registeredEligible: true,
      },
      {
        promptText: 'What should I do right after making a visible mistake at work or college?',
        shortDescription: 'Own it, correct it, and rebuild trust without defensiveness',
        l3Parent: 'Decisive Action Frameworks',
        guestEligible: true,
        registeredEligible: true,
      },
      {
        promptText: 'How do I ask senior leaders for guidance without feeling like a burden?',
        shortDescription: 'How to structure high-impact, respectful mentorship requests',
        l3Parent: 'Boundary Setting & Saying No',
        guestEligible: true,
        registeredEligible: true,
      },
      {
        promptText: 'How can I stay calm and articulate under unexpected questioning?',
        shortDescription: 'The "Pause-Acknowledge-Answer" method for high-pressure moments',
        l3Parent: 'Presentation Confidence',
        guestEligible: true,
        registeredEligible: true,
      },
    ];

    for (const q of l4Questions) {
      const parentNode = l3Nodes[q.l3Parent];
      if (parentNode) {
        const existing = await (prisma as any).questionPrompt.findFirst({
          where: { promptText: q.promptText },
        });
        if (!existing) {
          await (prisma as any).questionPrompt.create({
            data: {
              promptText: q.promptText,
              shortDescription: q.shortDescription,
              taxonomyNodeId: parentNode.id,
              publishStatus: 'published',
              guestEligible: q.guestEligible,
              registeredEligible: q.registeredEligible,
              version: 1,
            },
          });
        }
      }
    }

    // Concern Prompts (User-facing plain language statements mapped to hidden L2 nodes)
    const concernDefinitions = [
      {
        promptText: 'I freeze or stay quiet during important meetings or discussions',
        l2Parent: 'Public Speaking & Meeting Anxiety',
        order: 1,
      },
      {
        promptText: 'I constantly second-guess my decisions and overthink simple choices',
        l2Parent: 'Overthinking & Action Paralysis',
        order: 2,
      },
      {
        promptText: 'I struggle with confidence and feel like I don\'t belong',
        l2Parent: 'Self-Doubt & Imposter Feelings',
        order: 3,
      },
      {
        promptText: 'I get anxious before interviews, presentations, or pitches',
        l2Parent: 'Public Speaking & Meeting Anxiety',
        order: 4,
      },
      {
        promptText: 'I have trouble setting boundaries and saying no to people',
        l2Parent: 'Assertiveness & Difficult Conversations',
        order: 5,
      },
      {
        promptText: 'I feel overwhelmed by stress, burnout, and emotional fatigue',
        l2Parent: 'Stress, Burnout & Emotional Energy',
        order: 6,
      },
      {
        promptText: 'I need clarity on my career path and interview confidence',
        l2Parent: 'Interview & Career Positioning',
        order: 7,
      },
      {
        promptText: 'I want better study habits and learning productivity',
        l2Parent: 'Academic Direction & Study Strategy',
        order: 8,
      },
    ];

    for (const c of concernDefinitions) {
      const l2Node = l2Nodes[c.l2Parent];
      if (l2Node) {
        const existing = await (prisma as any).concernPrompt.findFirst({
          where: { promptText: c.promptText },
        });
        if (!existing) {
          await (prisma as any).concernPrompt.create({
            data: {
              promptText: c.promptText,
              taxonomyNodeId: l2Node.id,
              order: c.order,
              active: true,
            },
          });
        }
      }
    }
  }

  console.log('✅ Seed complete!');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
