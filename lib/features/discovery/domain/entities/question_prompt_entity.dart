// lib/features/discovery/domain/entities/question_prompt_entity.dart

class QuestionPromptEntity {
  final String questionId;
  final String prompt;
  final String? shortDescription;
  final String? displayAsset;
  final String? safeReasonLabel;

  const QuestionPromptEntity({
    required this.questionId,
    required this.prompt,
    this.shortDescription,
    this.displayAsset,
    this.safeReasonLabel,
  });

  factory QuestionPromptEntity.fromJson(Map<String, dynamic> json) {
    return QuestionPromptEntity(
      questionId: (json['questionId'] ?? json['id'] ?? '') as String,
      prompt: (json['prompt'] ?? json['content'] ?? json['promptText'] ?? '') as String,
      shortDescription: json['shortDescription'] as String?,
      displayAsset: json['displayAsset'] as String?,
      safeReasonLabel: json['safeReasonLabel'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'prompt': prompt,
    'shortDescription': shortDescription,
    'displayAsset': displayAsset,
    'safeReasonLabel': safeReasonLabel,
  };
}

