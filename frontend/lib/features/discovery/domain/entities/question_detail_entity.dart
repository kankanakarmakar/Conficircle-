// lib/features/discovery/domain/entities/question_detail_entity.dart

class PermittedActionEntity {
  final String actionType; // 'quicktip' | 'video' | 'assessment'
  final bool enabled;
  final String? reason; // 'ACCOUNT_REQUIRED' | 'QUOTA_EXHAUSTED'
  final int? quotaRemaining;

  const PermittedActionEntity({
    required this.actionType,
    required this.enabled,
    this.reason,
    this.quotaRemaining,
  });

  factory PermittedActionEntity.fromJson(Map<String, dynamic> json) {
    return PermittedActionEntity(
      actionType: json['actionType'] as String? ?? 'quicktip',
      enabled: json['enabled'] as bool? ?? false,
      reason: json['reason'] as String?,
      quotaRemaining: (json['quotaRemaining'] as num?)?.toInt(),
    );
  }
}

class QuestionDetailEntity {
  final String questionId;
  final String prompt;
  final String? shortDescription;
  final String? displayAsset;
  final List<PermittedActionEntity> permittedActions;
  final List<Map<String, dynamic>> quickTips;
  final List<Map<String, dynamic>> videoSolutions;
  final List<Map<String, dynamic>> assessments;

  const QuestionDetailEntity({
    required this.questionId,
    required this.prompt,
    this.shortDescription,
    this.displayAsset,
    required this.permittedActions,
    this.quickTips = const [],
    this.videoSolutions = const [],
    this.assessments = const [],
  });

  factory QuestionDetailEntity.fromJson(Map<String, dynamic> json) {
    final actionsRaw = json['permittedContentActions'] as List<dynamic>? ?? [];
    return QuestionDetailEntity(
      questionId: (json['questionId'] ?? '') as String,
      prompt: (json['prompt'] ?? '') as String,
      shortDescription: json['shortDescription'] as String?,
      displayAsset: json['displayAsset'] as String?,
      permittedActions: actionsRaw
          .map((a) => PermittedActionEntity.fromJson(a as Map<String, dynamic>))
          .toList(),
      quickTips: (json['quickTips'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>(),
      videoSolutions: (json['videoSolutions'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>(),
      assessments: (json['assessments'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>(),
    );
  }
}

