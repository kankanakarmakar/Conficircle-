// lib/models/resource.dart

enum ResourceType { article, video, template, framework, guide, presentation }

class Resource {
  final String id;
  final String title;
  final String description;
  final ResourceType type;
  final String category;
  final String? imageUrl;
  final String? url;
  final String? duration;
  final String? author;
  final int popularity;
  final List<String> tags;
  bool isSaved;

  Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    this.imageUrl,
    this.url,
    this.duration,
    this.author,
    this.popularity = 0,
    this.tags = const [],
    this.isSaved = false,
  });

  String get typeLabel {
    switch (type) {
      case ResourceType.article: return 'Article';
      case ResourceType.video: return 'Video';
      case ResourceType.template: return 'Template';
      case ResourceType.framework: return 'Framework';
      case ResourceType.guide: return 'Guide';
      case ResourceType.presentation: return 'Presentation';
    }
  }

  String get typeEmoji {
    switch (type) {
      case ResourceType.article: return '📄';
      case ResourceType.video: return '🎬';
      case ResourceType.template: return '📋';
      case ResourceType.framework: return '🔧';
      case ResourceType.guide: return '📖';
      case ResourceType.presentation: return '📊';
    }
  }
}
