// lib/features/discovery/domain/entities/discovery_batch_entity.dart
import 'question_prompt_entity.dart';

class DiscoveryBatchEntity {
  final String batchId;
  final String audience; // "guest" | "registered"
  final List<QuestionPromptEntity> items;
  final int? expiresAt;

  const DiscoveryBatchEntity({
    required this.batchId,
    required this.audience,
    required this.items,
    this.expiresAt,
  });

  factory DiscoveryBatchEntity.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return DiscoveryBatchEntity(
      batchId: (json['batchId'] ?? '') as String,
      audience: (json['audience'] ?? 'guest') as String,
      items: rawItems
          .map((e) => QuestionPromptEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      expiresAt: (json['expiresAt'] as num?)?.toInt(),
    );
  }
}

