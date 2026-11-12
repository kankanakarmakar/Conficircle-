// lib/models/program.dart

enum ProgramType {
  assessment,
  quickAction,
  selfPaced,
  webinar,
  program,
  oneToOne,
  mentorship,
  advanced,
}

enum ProgramStatus {
  notExplored,
  inProgress,
  completed,
}

class Program {
  final String id;
  final String name;
  final String description;
  final ProgramType type;
  final bool isFree;
  final double? price;
  final String? category;
  final String? duration;
  final String? instructor;
  final int? minConfiScore;
  final int? maxConfiScore;
  final int? targetConfiScore;
  final int popularity;
  final String emoji;
  final String colorHex;
  ProgramStatus status;
  DateTime? lastActivityAt;
  int activityCount;
  double progressPercent;

  Program({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.isFree = true,
    this.price,
    this.category,
    this.duration,
    this.instructor,
    this.minConfiScore,
    this.maxConfiScore,
    this.targetConfiScore,
    this.popularity = 0,
    this.emoji = '📚',
    this.colorHex = '#173883',
    this.status = ProgramStatus.notExplored,
    this.lastActivityAt,
    this.activityCount = 0,
    this.progressPercent = 0.0,
  });

  String get typeLabel {
    switch (type) {
      case ProgramType.assessment: return 'Assessment';
      case ProgramType.quickAction: return 'Quick Action';
      case ProgramType.selfPaced: return 'Self-paced';
      case ProgramType.webinar: return 'Free Webinar';
      case ProgramType.program: return 'Program';
      case ProgramType.oneToOne: return '1-1 Session';
      case ProgramType.mentorship: return 'Mentorship';
      case ProgramType.advanced: return 'Advanced';
    }
  }

  String get priceLabel => isFree ? 'FREE' : '₹${price?.toStringAsFixed(0) ?? ''}';
}
