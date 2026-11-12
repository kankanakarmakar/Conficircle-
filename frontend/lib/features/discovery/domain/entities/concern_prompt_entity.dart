// lib/features/discovery/domain/entities/concern_prompt_entity.dart

class ConcernPromptEntity {
  final String id;
  final String promptText;
  final int order;
  final bool isSelected;

  const ConcernPromptEntity({
    required this.id,
    required this.promptText,
    this.order = 0,
    this.isSelected = false,
  });

  factory ConcernPromptEntity.fromJson(Map<String, dynamic> json) {
    return ConcernPromptEntity(
      id: (json['id'] ?? '') as String,
      promptText: (json['promptText'] ?? json['content'] ?? '') as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
      isSelected: (json['isSelected'] as bool?) ?? false,
    );
  }

  ConcernPromptEntity copyWith({
    String? id,
    String? promptText,
    int? order,
    bool? isSelected,
  }) {
    return ConcernPromptEntity(
      id: id ?? this.id,
      promptText: promptText ?? this.promptText,
      order: order ?? this.order,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

