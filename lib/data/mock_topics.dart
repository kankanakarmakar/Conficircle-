// lib/data/mock_topics.dart

class TopicTip {
  final String emoji;
  final String type; // 'video' | 'article' | 'quote' | 'challenge'
  final String title;
  final String body;
  final String? duration;

  const TopicTip({
    required this.emoji,
    required this.type,
    required this.title,
    required this.body,
    this.duration,
  });
}

class TopicQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const TopicQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class TopicResource {
  final String emoji;
  final String title;
  final String subtitle;
  final String tag; // 'Course' | 'Program' | 'Workshop' | 'Article'
  final String duration;

  const TopicResource({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.duration,
  });
}

class AppTopic {
  final String id;
  final String emoji;
  final String title;
  final String subtitle;
  final int colorHex;
  final List<TopicTip> tips;
  final List<TopicQuestion> questions; // 5 questions, 2-minute timer
  final List<TopicResource> resources;

  const AppTopic({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.colorHex,
    required this.tips,
    required this.questions,
    required this.resources,
  });
}

final List<AppTopic> allTopics = [
  // ─── Career Clarity ──────────────────────────────────────────
  AppTopic(
    id: 'career',
    emoji: '🎯',
    title: 'Career Clarity',
    subtitle: 'Know where you\'re headed',
    colorHex: 0xFF173883,
    tips: const [
      TopicTip(
        emoji: '🎬',
        type: 'video',
        title: 'How to discover your ideal career in 3 steps',
        body: 'Watch this 4-minute breakdown on using your strengths, values, and interests to map a career direction.',
        duration: '4 min video',
      ),
      TopicTip(
        emoji: '📝',
        type: 'article',
        title: 'The "Just-in-Time" career exploration method',
        body: 'Don\'t plan 10 years ahead. Instead, make informed next-step decisions. Here\'s how to do it right now.',
        duration: '3 min read',
      ),
      TopicTip(
        emoji: '⚡',
        type: 'challenge',
        title: '5-minute challenge: Your future interview',
        body: 'Close your eyes. Imagine it\'s 5 years from now. What is your job title? What problem are you solving? Write 3 sentences about it.',
        duration: '5 min',
      ),
    ],
    questions: const [
      TopicQuestion(
        question: 'Which of these best helps you identify a good career fit?',
        options: ['Salary alone', 'Strengths + values + interests', 'What your parents suggest', 'Trending job titles'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Informational interviews help you:',
        options: ['Get a job immediately', 'Learn about roles from real people', 'Skip the resume', 'Find internships only'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'What does "career exploration" mean for a student?',
        options: ['Picking one career and sticking to it', 'Trying multiple paths to find the best fit', 'Only applying for jobs', 'Studying harder'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'A "skills gap" means:',
        options: ['You have no skills', 'Skills you need but don\'t yet have', 'Skills you have but don\'t need', 'A resume section'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'The best time to start career exploration is:',
        options: ['After graduation', 'In your final year only', 'As early as possible', 'When you fail an exam'],
        correctIndex: 2,
      ),
    ],
    resources: const [
      TopicResource(emoji: '🎓', title: 'Career Design Thinking', subtitle: 'Stanford d.school method for students', tag: 'Course', duration: '2 hrs'),
      TopicResource(emoji: '🗺️', title: 'Ikigai: Find Your Purpose', subtitle: 'Japanese framework for career + life clarity', tag: 'Workshop', duration: '45 min'),
      TopicResource(emoji: '📚', title: 'What Color Is Your Parachute?', subtitle: 'The classic career discovery guide', tag: 'Article', duration: '10 min read'),
    ],
  ),

  // ─── Confidence & Self-Worth ──────────────────────────────────
  AppTopic(
    id: 'confidence',
    emoji: '💪',
    title: 'Confidence',
    subtitle: 'Own who you are',
    colorHex: 0xFFF2432C,
    tips: const [
      TopicTip(
        emoji: '🎬',
        type: 'video',
        title: 'The confidence-competence loop explained',
        body: 'Confidence follows competence. Watch this short video to understand why acting first builds confidence faster than thinking about it.',
        duration: '5 min video',
      ),
      TopicTip(
        emoji: '💬',
        type: 'quote',
        title: '"You don\'t get confident by waiting to feel ready"',
        body: 'Action creates confidence. Every time you do something slightly outside your comfort zone, your brain recalibrates what "normal" is for you.',
        duration: '1 min read',
      ),
      TopicTip(
        emoji: '⚡',
        type: 'challenge',
        title: 'Power pose challenge',
        body: 'Stand in a power pose for 2 minutes before your next big moment. Research shows this measurably reduces cortisol and boosts testosterone.',
        duration: '2 min',
      ),
    ],
    questions: const [
      TopicQuestion(
        question: 'Confidence is best built by:',
        options: ['Waiting until you feel ready', 'Taking small actions consistently', 'Watching motivational videos', 'Avoiding failure'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Self-worth is:',
        options: ['Tied to achievements', 'Dependent on others\' opinions', 'Inherent — not earned', 'Only for confident people'],
        correctIndex: 2,
      ),
      TopicQuestion(
        question: 'Imposter syndrome means:',
        options: ['You are actually incompetent', 'Doubting your abilities despite evidence of success', 'Being fake at work', 'Having low grades'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Which habit most builds self-confidence over time?',
        options: ['Comparing yourself to others', 'Keeping small promises to yourself', 'Avoiding challenges', 'Seeking constant approval'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Body language affects confidence because:',
        options: ['It impresses others', 'It gives feedback signals to your own brain', 'It is cultural', 'It only helps in interviews'],
        correctIndex: 1,
      ),
    ],
    resources: const [
      TopicResource(emoji: '🌟', title: 'The Confidence Code', subtitle: 'Science of building real confidence', tag: 'Program', duration: '1.5 hrs'),
      TopicResource(emoji: '🎤', title: 'Public Speaking Bootcamp', subtitle: 'Speak with conviction in 7 days', tag: 'Course', duration: '7 days'),
      TopicResource(emoji: '📖', title: 'Authentic Confidence Workbook', subtitle: 'Exercises for lasting self-belief', tag: 'Workshop', duration: '30 min'),
    ],
  ),

  // ─── Communication ────────────────────────────────────────────
  AppTopic(
    id: 'communication',
    emoji: '💬',
    title: 'Communication',
    subtitle: 'Say it clearly, say it well',
    colorHex: 0xFF4475D7,
    tips: const [
      TopicTip(
        emoji: '🎬',
        type: 'video',
        title: 'The 3-part structure for any clear message',
        body: 'Context → Point → Action. Every great communicator uses this structure. Watch how to apply it in emails, presentations and conversations.',
        duration: '3 min video',
      ),
      TopicTip(
        emoji: '📝',
        type: 'article',
        title: 'Active listening: the most underrated skill',
        body: 'Most people listen to reply, not to understand. Learn the 4 levels of listening and which one creates breakthrough conversations.',
        duration: '4 min read',
      ),
      TopicTip(
        emoji: '⚡',
        type: 'challenge',
        title: 'The 1-sentence challenge',
        body: 'Describe what you\'re working on right now in exactly ONE sentence. If you can\'t, your thinking isn\'t clear enough yet.',
        duration: '3 min',
      ),
    ],
    questions: const [
      TopicQuestion(
        question: 'The most important skill in communication is:',
        options: ['Talking more', 'Active listening', 'Using complex vocabulary', 'Speaking fast'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Non-verbal communication accounts for approximately:',
        options: ['10% of your message', '30% of your message', '55–70% of your message', '100% of your message'],
        correctIndex: 2,
      ),
      TopicQuestion(
        question: 'When you disagree, the best approach is to:',
        options: ['Argue your point forcefully', 'Acknowledge the other view first, then share yours', 'Stay silent', 'Change your opinion immediately'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'An "assertive" communication style means:',
        options: ['Aggressive and demanding', 'Passive and agreeable', 'Clear, direct and respectful', 'Emotional and reactive'],
        correctIndex: 2,
      ),
      TopicQuestion(
        question: 'Giving feedback effectively requires:',
        options: ['Focusing only on what went wrong', 'Being vague to avoid conflict', 'Specific examples and a growth focus', 'Waiting for the right mood'],
        correctIndex: 2,
      ),
    ],
    resources: const [
      TopicResource(emoji: '🗣️', title: 'Effective Communication for Students', subtitle: 'From classroom to boardroom', tag: 'Course', duration: '3 hrs'),
      TopicResource(emoji: '✍️', title: 'Write to Be Understood', subtitle: 'Clear writing for emails and essays', tag: 'Workshop', duration: '1 hr'),
      TopicResource(emoji: '🤝', title: 'Difficult Conversations Playbook', subtitle: 'Navigate tough talks with ease', tag: 'Program', duration: '45 min'),
    ],
  ),

  // ─── Emotional Intelligence ───────────────────────────────────
  AppTopic(
    id: 'eq',
    emoji: '🧠',
    title: 'Emotional Intelligence',
    subtitle: 'Understand yourself & others',
    colorHex: 0xFF6B2D9E,
    tips: const [
      TopicTip(
        emoji: '🎬',
        type: 'video',
        title: 'What is EQ and why it matters more than IQ',
        body: 'Research shows EQ accounts for 58% of job performance. Watch this quick explainer on the 5 components of emotional intelligence.',
        duration: '5 min video',
      ),
      TopicTip(
        emoji: '📝',
        type: 'article',
        title: 'Name your emotions to tame them',
        body: 'Neuroscience shows that labeling an emotion reduces its intensity by 50%. Here\'s a simple emotion vocabulary to build your EQ.',
        duration: '3 min read',
      ),
      TopicTip(
        emoji: '⚡',
        type: 'challenge',
        title: 'Emotion check-in',
        body: 'Right now — name exactly what you\'re feeling (be specific: not just "stressed" but "overwhelmed by uncertainty"). Write it down.',
        duration: '2 min',
      ),
    ],
    questions: const [
      TopicQuestion(
        question: 'Emotional intelligence primarily involves:',
        options: ['Suppressing emotions', 'Recognizing and managing emotions in self and others', 'Being very emotional', 'Having high IQ'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Empathy means:',
        options: ['Agreeing with everyone', 'Feeling others\' emotions as your own', 'Understanding another\'s perspective without judgment', 'Giving advice quickly'],
        correctIndex: 2,
      ),
      TopicQuestion(
        question: 'Self-regulation in EQ refers to:',
        options: ['Suppressing all negative feelings', 'Managing your emotional responses thoughtfully', 'Never getting angry', 'Controlling others\' feelings'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Which is a sign of HIGH emotional intelligence?',
        options: ['Reacting immediately to criticism', 'Blaming others for your mood', 'Pausing before responding when upset', 'Avoiding all conflict'],
        correctIndex: 2,
      ),
      TopicQuestion(
        question: 'Social awareness in EQ means:',
        options: ['Being popular', 'Reading room dynamics and others\' emotional states', 'Using social media well', 'Having many friends'],
        correctIndex: 1,
      ),
    ],
    resources: const [
      TopicResource(emoji: '🧩', title: 'EQ at Work & College', subtitle: 'Apply emotional intelligence daily', tag: 'Program', duration: '2 hrs'),
      TopicResource(emoji: '🫁', title: 'Mindfulness-Based Stress Reduction', subtitle: 'Regulate emotions through awareness', tag: 'Course', duration: '4 hrs'),
      TopicResource(emoji: '📊', title: 'EQ Assessment + Debrief', subtitle: 'Know your EQ profile', tag: 'Workshop', duration: '30 min'),
    ],
  ),

  // ─── Time Management ─────────────────────────────────────────
  AppTopic(
    id: 'time',
    emoji: '⏰',
    title: 'Time Management',
    subtitle: 'Do more of what matters',
    colorHex: 0xFF27AE60,
    tips: const [
      TopicTip(
        emoji: '🎬',
        type: 'video',
        title: 'The 2-minute rule that changes everything',
        body: 'If a task takes less than 2 minutes — do it now. This simple rule from David Allen\'s GTD system eliminates 40% of procrastination.',
        duration: '3 min video',
      ),
      TopicTip(
        emoji: '📝',
        type: 'article',
        title: 'Time blocking: the student\'s superpower',
        body: 'Schedule your tasks in themed blocks instead of a to-do list. Studies show this increases daily output by up to 30%.',
        duration: '4 min read',
      ),
      TopicTip(
        emoji: '⚡',
        type: 'challenge',
        title: 'MIT challenge (Most Important Task)',
        body: 'Before opening your phone tomorrow morning, write down your 3 Most Important Tasks for the day. Do those first. Nothing else.',
        duration: '5 min',
      ),
    ],
    questions: const [
      TopicQuestion(
        question: 'Parkinson\'s Law states that:',
        options: ['Work expands to fill the time allotted', 'More time = more productivity', 'Tasks are always easier than expected', 'Deadlines cause stress'],
        correctIndex: 0,
      ),
      TopicQuestion(
        question: 'The Eisenhower Matrix helps you:',
        options: ['Budget money', 'Prioritize tasks by urgency and importance', 'Schedule meetings', 'Track calories'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Procrastination is primarily caused by:',
        options: ['Laziness', 'Emotional avoidance of a task', 'Lack of intelligence', 'Too many tasks'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'The Pomodoro Technique uses:',
        options: ['25-minute focused work + 5-minute break cycles', 'Working 8 hours straight', 'Multitasking on multiple screens', 'No breaks'],
        correctIndex: 0,
      ),
      TopicQuestion(
        question: 'The best time to plan your day is:',
        options: ['During lunch', 'The night before or first thing in the morning', 'Whenever you feel like it', 'After all tasks are done'],
        correctIndex: 1,
      ),
    ],
    resources: const [
      TopicResource(emoji: '⚡', title: 'Deep Work: Focus Masterclass', subtitle: 'Do more in less time through focus', tag: 'Course', duration: '2 hrs'),
      TopicResource(emoji: '📅', title: 'Student Productivity Blueprint', subtitle: 'A complete semester planning system', tag: 'Program', duration: '1 hr'),
      TopicResource(emoji: '🎯', title: 'Beat Procrastination Workshop', subtitle: 'Science-backed methods that work', tag: 'Workshop', duration: '45 min'),
    ],
  ),

  // ─── Wellbeing ────────────────────────────────────────────────
  AppTopic(
    id: 'wellbeing',
    emoji: '🌿',
    title: 'Wellbeing',
    subtitle: 'Thrive, don\'t just survive',
    colorHex: 0xFF16A085,
    tips: const [
      TopicTip(
        emoji: '🎬',
        type: 'video',
        title: 'How stress physically affects your brain',
        body: 'Chronic stress shrinks the hippocampus. Watch this 5-minute explainer to understand the biology and what you can do about it today.',
        duration: '5 min video',
      ),
      TopicTip(
        emoji: '📝',
        type: 'article',
        title: 'The 5-4-3-2-1 grounding technique',
        body: 'Name 5 things you see, 4 you can touch, 3 you hear, 2 you smell, 1 you taste. This instantly anchors you when anxiety spikes.',
        duration: '2 min read',
      ),
      TopicTip(
        emoji: '⚡',
        type: 'challenge',
        title: 'Box breathing — right now',
        body: 'Breathe in for 4 counts, hold for 4, out for 4, hold for 4. Repeat 4 times. This is used by Navy SEALs to calm under pressure.',
        duration: '3 min',
      ),
    ],
    questions: const [
      TopicQuestion(
        question: 'Which activity has the strongest evidence for improving mental wellbeing?',
        options: ['Scrolling social media', 'Regular physical exercise', 'Watching TV', 'Sleeping 12+ hours'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Burnout is characterized by:',
        options: ['Too much energy', 'Emotional exhaustion, detachment, and reduced efficacy', 'Being too busy', 'Loving your work too much'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Sleep deprivation most directly impacts:',
        options: ['Hair growth', 'Decision-making and emotional regulation', 'Physical strength', 'Social popularity'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Setting boundaries is important because:',
        options: ['It makes others unhappy', 'It preserves your mental and physical energy', 'It is rude', 'It limits your opportunities'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'A healthy response to failure is:',
        options: ['Giving up', 'Blaming others', 'Reflecting, learning, and adjusting', 'Pretending it didn\'t happen'],
        correctIndex: 2,
      ),
    ],
    resources: const [
      TopicResource(emoji: '🌱', title: 'Student Wellbeing Essentials', subtitle: 'Build a life that doesn\'t need escaping', tag: 'Program', duration: '3 hrs'),
      TopicResource(emoji: '🧘', title: 'Mindfulness in 10 Days', subtitle: 'Reduce stress, improve focus', tag: 'Course', duration: '10 days'),
      TopicResource(emoji: '😴', title: 'Sleep Science for Students', subtitle: 'Optimize your sleep for performance', tag: 'Workshop', duration: '1 hr'),
    ],
  ),

  // ─── Leadership ───────────────────────────────────────────────
  AppTopic(
    id: 'leadership',
    emoji: '🌟',
    title: 'Leadership',
    subtitle: 'Lead yourself first',
    colorHex: 0xFFE67E22,
    tips: const [
      TopicTip(
        emoji: '🎬',
        type: 'video',
        title: 'Why every student is a leader',
        body: 'Leadership isn\'t a title. It\'s a set of behaviours. Watch how students in ordinary situations demonstrate extraordinary leadership.',
        duration: '4 min video',
      ),
      TopicTip(
        emoji: '📝',
        type: 'article',
        title: 'Servant leadership: the model that actually works',
        body: 'The best leaders ask "How can I help?" not "How do I look?" Here\'s why servant leadership outperforms command-and-control.',
        duration: '4 min read',
      ),
      TopicTip(
        emoji: '⚡',
        type: 'challenge',
        title: 'Lead in the next 24 hours',
        body: 'Find ONE moment tomorrow where you take initiative, help without being asked, or make a decision others were avoiding. Do it.',
        duration: '24 hr challenge',
      ),
    ],
    questions: const [
      TopicQuestion(
        question: 'Good leadership starts with:',
        options: ['Having a title', 'Leading yourself — managing your own actions and mindset', 'Being popular', 'Having authority over others'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'The most important quality of an effective leader is:',
        options: ['Confidence alone', 'Intelligence alone', 'The ability to inspire and enable others', 'Being the loudest in the room'],
        correctIndex: 2,
      ),
      TopicQuestion(
        question: 'Delegation means:',
        options: ['Doing everything yourself', 'Assigning tasks AND the authority to complete them', 'Avoiding responsibility', 'Taking credit for others\' work'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Psychological safety in a team means:',
        options: ['Physical safety from harm', 'A culture where people feel safe to speak up and take risks', 'Everyone agrees with the leader', 'No disagreements'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Leadership development for students means:',
        options: ['Waiting for a leadership role', 'Only running for student council', 'Growing leadership skills in everyday situations', 'Being the best academically'],
        correctIndex: 2,
      ),
    ],
    resources: const [
      TopicResource(emoji: '👑', title: 'Student Leadership Academy', subtitle: 'Build your leadership identity', tag: 'Program', duration: '4 hrs'),
      TopicResource(emoji: '🤝', title: 'Team Dynamics & Collaboration', subtitle: 'Lead and thrive in any team', tag: 'Course', duration: '2 hrs'),
      TopicResource(emoji: '📋', title: 'Leadership Style Discovery', subtitle: 'Find your unique leadership approach', tag: 'Workshop', duration: '45 min'),
    ],
  ),

  // ─── Financial Literacy ───────────────────────────────────────
  AppTopic(
    id: 'finance',
    emoji: '💰',
    title: 'Financial Literacy',
    subtitle: 'Money skills for real life',
    colorHex: 0xFF2C3E50,
    tips: const [
      TopicTip(
        emoji: '🎬',
        type: 'video',
        title: 'The 50/30/20 rule for students',
        body: 'Budget 50% on needs, 30% on wants, 20% on savings. Even on a student budget, this simple rule builds financial discipline fast.',
        duration: '4 min video',
      ),
      TopicTip(
        emoji: '📝',
        type: 'article',
        title: 'Why compound interest is your best friend',
        body: 'Rs 1000 invested at 21 is worth more than Rs 10,000 invested at 31. The math is shocking — and motivating.',
        duration: '3 min read',
      ),
      TopicTip(
        emoji: '⚡',
        type: 'challenge',
        title: 'Track every rupee for 3 days',
        body: 'For the next 72 hours, write down EVERY expense. No matter how small. At the end, you\'ll be surprised — and enlightened.',
        duration: '3 day challenge',
      ),
    ],
    questions: const [
      TopicQuestion(
        question: 'An emergency fund should ideally cover:',
        options: ['1 day of expenses', '3–6 months of essential expenses', 'Only one month', 'As much as possible without limit'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Inflation means:',
        options: ['Your money gains value over time', 'The purchasing power of money decreases over time', 'Prices never change', 'Savings grow automatically'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'The best thing a student can do financially is:',
        options: ['Spend freely now, save later', 'Start saving and investing as early as possible', 'Avoid all debt always', 'Earn more, worry later'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'Compound interest works by:',
        options: ['Earning interest on original amount only', 'Earning interest on interest already earned', 'Reducing debt automatically', 'Growing only in banks'],
        correctIndex: 1,
      ),
      TopicQuestion(
        question: 'A budget is best described as:',
        options: ['A restriction on spending', 'A plan for your money', 'Something only rich people need', 'A bank requirement'],
        correctIndex: 1,
      ),
    ],
    resources: const [
      TopicResource(emoji: '💵', title: 'Personal Finance for Students', subtitle: 'Master money before your first job', tag: 'Course', duration: '3 hrs'),
      TopicResource(emoji: '📈', title: 'Investing 101: Start at 20', subtitle: 'Why and how to start investing now', tag: 'Workshop', duration: '1 hr'),
      TopicResource(emoji: '🏦', title: 'Debt & Credit Card Literacy', subtitle: 'Use credit without getting trapped', tag: 'Program', duration: '45 min'),
    ],
  ),
];
