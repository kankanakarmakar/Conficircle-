// lib/models/confi_score.dart

class ConfiCategoryScore {
  final String category;
  final double score; // 0–100
  final String emoji;
  final String description;

  const ConfiCategoryScore({
    required this.category,
    required this.score,
    required this.emoji,
    required this.description,
  });

  String get grade {
    if (score >= 80) return 'Strong';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Growing';
    return 'Needs Focus';
  }
}

class ConfiScore {
  final double overall; // 0–100
  final int level; // 1–12
  final List<ConfiCategoryScore> categories;
  final DateTime assessedAt;

  const ConfiScore({
    required this.overall,
    required this.level,
    required this.categories,
    required this.assessedAt,
  });

  String get levelName {
    const names = [
      'Spark', 'Seeker', 'Explorer', 'Aligner', 'Builder', 'Riser',
      'Achiever', 'Connector', 'Influencer', 'Visionary', 'Champion', 'Legend',
    ];
    return names[(level - 1).clamp(0, 11)];
  }

  String get levelSubtitle {
    const subtitles = [
      'Just Beginning', 'Finding Yourself', 'Discovering Paths', 'Finding Direction',
      'Taking Shape', 'Gaining Momentum', 'Making Impact', 'Building Bridges',
      'Leading Others', 'Defining Purpose', 'Inspiring Change', 'Leaving a Legacy',
    ];
    return subtitles[(level - 1).clamp(0, 11)];
  }

  /// Returns a sample ConfiScore based on an overall score (0–100).
  static ConfiScore fromOverall(double overallScore, int level) {
    return ConfiScore(
      overall: overallScore,
      level: level,
      assessedAt: DateTime.now(),
      categories: [
        ConfiCategoryScore(
          category: 'Career Clarity',
          score: (overallScore * 0.9).clamp(0, 100),
          emoji: '🎯',
          description: 'How clear you are about your career path',
        ),
        ConfiCategoryScore(
          category: 'Confidence',
          score: (overallScore * 1.1).clamp(0, 100),
          emoji: '💪',
          description: 'How confident you feel in daily interactions',
        ),
        ConfiCategoryScore(
          category: 'Personal Effectiveness',
          score: (overallScore * 0.95).clamp(0, 100),
          emoji: '⚡',
          description: 'How well you manage time and productivity',
        ),
        ConfiCategoryScore(
          category: 'Communication',
          score: (overallScore * 1.05).clamp(0, 100),
          emoji: '🗣️',
          description: 'How effectively you communicate with others',
        ),
        ConfiCategoryScore(
          category: 'Wellbeing',
          score: (overallScore * 0.85).clamp(0, 100),
          emoji: '🌿',
          description: 'How well you take care of your mental health',
        ),
      ],
    );
  }
}
