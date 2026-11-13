// lib/models/quick_action.dart

enum QuickActionCategory {
  career,
  confidence,
  communication,
  finance,
  wellbeing,
  leadership,
}

class QuickAction {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final QuickActionCategory category;
  final int durationMinutes;
  final String tipContent;
  final List<String> tags;
  bool isCompleted;
  bool isSaved;

  QuickAction({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.category,
    required this.durationMinutes,
    required this.tipContent,
    this.tags = const [],
    this.isCompleted = false,
    this.isSaved = false,
  });

  String get categoryLabel {
    switch (category) {
      case QuickActionCategory.career: return 'Career';
      case QuickActionCategory.confidence: return 'Confidence';
      case QuickActionCategory.communication: return 'Communication';
      case QuickActionCategory.finance: return 'Finance';
      case QuickActionCategory.wellbeing: return 'Wellbeing';
      case QuickActionCategory.leadership: return 'Leadership';
    }
  }

  String get durationLabel {
    if (durationMinutes < 60) return '${durationMinutes}m';
    return '${durationMinutes ~/ 60}h ${durationMinutes % 60}m';
  }
}

/// Sample quick actions used across ConfiZone
final List<QuickAction> allQuickActions = [
  QuickAction(
    id: 'QA001',
    title: 'Write Your 1-Minute Pitch',
    description: 'Practice introducing yourself confidently in 60 seconds.',
    emoji: '🎤',
    category: QuickActionCategory.communication,
    durationMinutes: 5,
    tipContent: 'Start with your name, what you study, one passion, and one goal. Keep it natural and enthusiastic!',
    tags: ['pitch', 'communication', 'self-intro'],
  ),
  QuickAction(
    id: 'QA002',
    title: 'Map Your Top 3 Skills',
    description: 'Identify and write down your strongest current skills.',
    emoji: '🗺️',
    category: QuickActionCategory.career,
    durationMinutes: 10,
    tipContent: 'Think about what you\'re naturally good at, what you enjoy, and what others praise you for. These are your core skills.',
    tags: ['skills', 'career', 'self-awareness'],
  ),
  QuickAction(
    id: 'QA003',
    title: 'Morning Power Ritual',
    description: 'Build a 5-minute morning ritual that sets your day.',
    emoji: '☀️',
    category: QuickActionCategory.wellbeing,
    durationMinutes: 5,
    tipContent: 'Try: 1 min gratitude, 1 min intention setting, 1 min deep breathing, 2 min light movement. Consistency is key!',
    tags: ['morning', 'ritual', 'wellbeing', 'habits'],
  ),
  QuickAction(
    id: 'QA004',
    title: 'Track Your Daily Wins',
    description: 'Write 3 wins from today — big or small.',
    emoji: '🏆',
    category: QuickActionCategory.confidence,
    durationMinutes: 5,
    tipContent: 'Wins can be anything: woke up on time, helped someone, finished a chapter. Celebrating small wins builds momentum!',
    tags: ['gratitude', 'wins', 'confidence', 'journaling'],
  ),
  QuickAction(
    id: 'QA005',
    title: 'LinkedIn Profile Quick Audit',
    description: 'Review and improve one section of your LinkedIn today.',
    emoji: '💼',
    category: QuickActionCategory.career,
    durationMinutes: 15,
    tipContent: 'Focus on one section at a time. Your headline should say what you do and what you\'re working towards, not just your college name.',
    tags: ['linkedin', 'career', 'profile', 'networking'],
  ),
  QuickAction(
    id: 'QA006',
    title: 'The STAR Story Bank',
    description: 'Write one STAR story from your past experience.',
    emoji: '⭐',
    category: QuickActionCategory.communication,
    durationMinutes: 15,
    tipContent: 'Situation → Task → Action → Result. Great for interviews! Think of a time you solved a problem, led something, or overcame a challenge.',
    tags: ['interview', 'communication', 'storytelling', 'career'],
  ),
];
