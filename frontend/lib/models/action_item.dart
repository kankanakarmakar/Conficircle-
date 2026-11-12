// lib/models/action_item.dart
class ActionItem {
  final String id;
  final String text;
  final String level1;
  final String level2;
  final String level3;
  final List<String> tags;
  final int popularity;
  final String emoji;
  final String colorHex;
  bool isVisible;

  ActionItem({
    required this.id,
    required this.text,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.tags,
    required this.popularity,
    required this.emoji,
    required this.colorHex,
    this.isVisible = true,
  });

  /// Top-level category (alias for level1) used by the recommendation engine
  String get category => level1;
}
