// lib/models/group.dart

enum GroupType { public, private }

class Group {
  final String id;
  final String name;
  final String description;
  final GroupType type;
  final String category;
  final String emoji;
  final int memberCount;
  final bool isJoined;
  final String? imageUrl;
  final List<String> tags;
  final String createdBy;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.category,
    required this.emoji,
    required this.memberCount,
    required this.createdBy,
    this.isJoined = false,
    this.imageUrl,
    this.tags = const [],
  });
}

class StudentCard {
  final String id;
  final String name;
  final String college;
  final String course;
  final int confiLevel;
  final double confiScore;
  final String avatarEmoji;
  final List<String> interests;
  final List<String> completedPrograms;

  StudentCard({
    required this.id,
    required this.name,
    required this.college,
    required this.course,
    required this.confiLevel,
    required this.confiScore,
    required this.avatarEmoji,
    this.interests = const [],
    this.completedPrograms = const [],
  });
}
