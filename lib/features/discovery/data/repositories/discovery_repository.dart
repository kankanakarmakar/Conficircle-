// lib/features/discovery/data/repositories/discovery_repository.dart
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api_client/api_client.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/guest/guest_storage.dart';
import '../../domain/entities/question_prompt_entity.dart';
import '../../domain/entities/concern_prompt_entity.dart';
import '../../domain/entities/discovery_batch_entity.dart';
import '../../domain/entities/question_detail_entity.dart';

abstract class DiscoveryRepository {
  Future<DiscoveryBatchEntity> getGuestQuestionBatch({int limit = 8, String? previousBatchId});
  Future<DiscoveryBatchEntity> shuffleGuestQuestionBatch({required String previousBatchId, List<String>? excludedIds});
  Future<DiscoveryBatchEntity> getRegisteredQuestionBatch({int limit = 6, String? context});
  Future<DiscoveryBatchEntity> shuffleRegisteredQuestionBatch({required String previousBatchId, List<String>? excludedIds});
  Future<QuestionDetailEntity> getQuestionDetail(String questionId);
  Future<List<ConcernPromptEntity>> getCuratedConcerns();
  Future<List<Map<String, dynamic>>> getUserProblemProfile();
  Future<Map<String, dynamic>> saveProblemProfile({required List<String> concernPromptIds, int priority = 1, bool consent = true});
  Future<Map<String, dynamic>> updateProblemProfile(String id, {String? status, int? priority});
  Future<void> recordDiscoveryEvent({required String eventType, required String questionId, Map<String, dynamic>? metadata});
}

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  DiscoveryRepositoryImpl({
    Dio? dio,
    GuestStorage? guestStorage,
  })  : dio = dio ?? Dio(BaseOptions(baseUrl: getBaseUrl())),
        guestStorage = guestStorage ??
            const GuestStorage(FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            ));

  final Dio dio;
  final GuestStorage guestStorage;

  // ── Curated Level 4 Catalog (Fallback / Offline) ─────────────────────────
  static const List<QuestionPromptEntity> _mockCatalog = [
    QuestionPromptEntity(
      questionId: 'l4-001',
      prompt: 'How do I stop overthinking in group meetings and actually speak up?',
      shortDescription: 'Quick tactics to contribute before hesitation takes over',
    ),
    QuestionPromptEntity(
      questionId: 'l4-002',
      prompt: 'What can I do when imposter syndrome kicks in before a presentation?',
      shortDescription: 'Mental grounding techniques to regain your calm',
    ),
    QuestionPromptEntity(
      questionId: 'l4-003',
      prompt: 'How do I make tough decisions without constantly second-guessing myself?',
      shortDescription: 'A practical framework to commit and move forward with conviction',
    ),
    QuestionPromptEntity(
      questionId: 'l4-004',
      prompt: 'How can I stop comparing my career journey to my peers on social media?',
      shortDescription: 'Refocusing on your personal timeline and real strengths',
    ),
    QuestionPromptEntity(
      questionId: 'l4-005',
      prompt: 'How do I set firm boundaries with friends or colleagues without feeling guilty?',
      shortDescription: 'Mindset shifts and boundary scripts for saying no cleanly',
    ),
    QuestionPromptEntity(
      questionId: 'l4-006',
      prompt: 'How should I answer "Tell me about a time you failed" in an interview?',
      shortDescription: 'Turn a past mistake into a compelling story of resilience',
    ),
    QuestionPromptEntity(
      questionId: 'l4-007',
      prompt: 'What is a 2-minute daily routine to reset when stress feels overwhelming?',
      shortDescription: 'Somatic breathing and nervous system calming tools',
    ),
    QuestionPromptEntity(
      questionId: 'l4-008',
      prompt: 'How can I retain what I study without having to re-read everything twice?',
      shortDescription: 'Active recall and spaced repetition in simple steps',
    ),
    QuestionPromptEntity(
      questionId: 'l4-009',
      prompt: 'How do I handle an awkward silence in a 1-on-1 conversation?',
      shortDescription: 'Natural follow-up prompts to keep conversations comfortable',
    ),
    QuestionPromptEntity(
      questionId: 'l4-010',
      prompt: 'What should I do right after making a visible mistake at work or college?',
      shortDescription: 'Own it, correct it, and rebuild trust without defensiveness',
    ),
    QuestionPromptEntity(
      questionId: 'l4-011',
      prompt: 'How do I ask senior leaders for guidance without feeling like a burden?',
      shortDescription: 'How to structure high-impact, respectful mentorship requests',
    ),
    QuestionPromptEntity(
      questionId: 'l4-012',
      prompt: 'How can I stay calm and articulate under unexpected questioning?',
      shortDescription: 'The "Pause-Acknowledge-Answer" method for high-pressure moments',
    ),
  ];

  static const List<ConcernPromptEntity> _mockConcerns = [
    ConcernPromptEntity(
      id: 'concern-01',
      promptText: 'I freeze or stay quiet during important meetings or discussions',
      order: 1,
    ),
    ConcernPromptEntity(
      id: 'concern-02',
      promptText: 'I constantly second-guess my decisions and overthink simple choices',
      order: 2,
    ),
    ConcernPromptEntity(
      id: 'concern-03',
      promptText: 'I struggle with confidence and feel like I don\'t belong',
      order: 3,
    ),
    ConcernPromptEntity(
      id: 'concern-04',
      promptText: 'I get anxious before interviews, presentations, or pitches',
      order: 4,
    ),
    ConcernPromptEntity(
      id: 'concern-05',
      promptText: 'I have trouble setting boundaries and saying no to people',
      order: 5,
    ),
    ConcernPromptEntity(
      id: 'concern-06',
      promptText: 'I feel overwhelmed by stress, burnout, and emotional fatigue',
      order: 6,
    ),
    ConcernPromptEntity(
      id: 'concern-07',
      promptText: 'I need clarity on my career path and interview confidence',
      order: 7,
    ),
    ConcernPromptEntity(
      id: 'concern-08',
      promptText: 'I want better study habits and learning productivity',
      order: 8,
    ),
  ];

  // In-memory session concerns for testing / offline
  final List<String> _userSelectedConcernIds = [];

  @override
  Future<DiscoveryBatchEntity> getGuestQuestionBatch({
    int limit = 8,
    String? previousBatchId,
  }) async {
    final batchSize = limit.clamp(7, 8);
    try {
      final guestRef = await guestStorage.getGuestRef();
      final response = await dio.get<Map<String, dynamic>>(
        '/v1/discovery/guest',
        queryParameters: {
          'limit': batchSize,
          if (previousBatchId != null) 'previous_batch_id': previousBatchId,
        },
        options: Options(headers: {
          if (guestRef != null) 'X-Guest-Ref': guestRef,
        }),
      );
      if (response.data != null) {
        return DiscoveryBatchEntity.fromJson(response.data!);
      }
    } catch (_) {
      // Fallback
    }

    // Diverse random sample of exactly batchSize items
    final shuffled = List<QuestionPromptEntity>.from(_mockCatalog)..shuffle(Random());
    return DiscoveryBatchEntity(
      batchId: 'mock-guest-batch-${DateTime.now().millisecondsSinceEpoch}',
      audience: 'guest',
      items: shuffled.take(batchSize).toList(),
      expiresAt: DateTime.now().millisecondsSinceEpoch + 3600000,
    );
  }

  @override
  Future<DiscoveryBatchEntity> shuffleGuestQuestionBatch({
    required String previousBatchId,
    List<String>? excludedIds,
  }) async {
    const batchSize = 8;
    try {
      final guestRef = await guestStorage.getGuestRef();
      final response = await dio.post<Map<String, dynamic>>(
        '/v1/discovery/guest/shuffle',
        data: {
          'previousBatchId': previousBatchId,
          'excludedIds': excludedIds ?? [],
        },
        options: Options(headers: {
          if (guestRef != null) 'X-Guest-Ref': guestRef,
        }),
      );
      if (response.data != null) {
        return DiscoveryBatchEntity.fromJson(response.data!);
      }
    } catch (_) {
      // Fallback
    }

    final excluded = (excludedIds ?? []).toSet();
    final pool = _mockCatalog.where((q) => !excluded.contains(q.questionId)).toList();
    final source = pool.length >= batchSize ? pool : _mockCatalog;
    final shuffled = List<QuestionPromptEntity>.from(source)..shuffle(Random());

    return DiscoveryBatchEntity(
      batchId: 'mock-guest-batch-${DateTime.now().millisecondsSinceEpoch}',
      audience: 'guest',
      items: shuffled.take(batchSize).toList(),
      expiresAt: DateTime.now().millisecondsSinceEpoch + 3600000,
    );
  }

  @override
  Future<DiscoveryBatchEntity> getRegisteredQuestionBatch({
    int limit = 6,
    String? context,
  }) async {
    final batchSize = limit.clamp(5, 6);
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/v1/discovery/registered',
        queryParameters: {
          'limit': batchSize,
          if (context != null) 'context': context,
        },
      );
      if (response.data != null) {
        return DiscoveryBatchEntity.fromJson(response.data!);
      }
    } catch (_) {
      // Fallback
    }

    final shuffled = List<QuestionPromptEntity>.from(_mockCatalog)..shuffle(Random());
    final items = shuffled.take(batchSize).map((q) {
      if (_userSelectedConcernIds.isNotEmpty && q.questionId == 'l4-001') {
        return QuestionPromptEntity(
          questionId: q.questionId,
          prompt: q.prompt,
          shortDescription: q.shortDescription,
          displayAsset: q.displayAsset,
          safeReasonLabel: 'Based on what you selected',
        );
      }
      return q;
    }).toList();

    return DiscoveryBatchEntity(
      batchId: 'mock-reg-batch-${DateTime.now().millisecondsSinceEpoch}',
      audience: 'registered',
      items: items,
    );
  }

  @override
  Future<DiscoveryBatchEntity> shuffleRegisteredQuestionBatch({
    required String previousBatchId,
    List<String>? excludedIds,
  }) async {
    const batchSize = 6;
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/v1/discovery/registered/shuffle',
        data: {
          'previousBatchId': previousBatchId,
          'excludedIds': excludedIds ?? [],
        },
      );
      if (response.data != null) {
        return DiscoveryBatchEntity.fromJson(response.data!);
      }
    } catch (_) {
      // Fallback
    }

    final excluded = (excludedIds ?? []).toSet();
    final pool = _mockCatalog.where((q) => !excluded.contains(q.questionId)).toList();
    final source = pool.length >= batchSize ? pool : _mockCatalog;
    final shuffled = List<QuestionPromptEntity>.from(source)..shuffle(Random());

    return DiscoveryBatchEntity(
      batchId: 'mock-reg-batch-${DateTime.now().millisecondsSinceEpoch}',
      audience: 'registered',
      items: shuffled.take(batchSize).toList(),
    );
  }

  @override
  Future<QuestionDetailEntity> getQuestionDetail(String questionId) async {
    try {
      final guestRef = await guestStorage.getGuestRef();
      final response = await dio.get<Map<String, dynamic>>(
        '/v1/questions/$questionId',
        options: Options(headers: {
          if (guestRef != null) 'X-Guest-Ref': guestRef,
        }),
      );
      if (response.data != null) {
        return QuestionDetailEntity.fromJson(response.data!);
      }
    } catch (_) {
      // Fallback
    }

    final q = _mockCatalog.firstWhere(
      (item) => item.questionId == questionId,
      orElse: () => _mockCatalog.first,
    );

    return QuestionDetailEntity(
      questionId: q.questionId,
      prompt: q.prompt,
      shortDescription: q.shortDescription,
      permittedActions: const [
        PermittedActionEntity(actionType: 'quicktip', enabled: true, quotaRemaining: 3),
        PermittedActionEntity(actionType: 'video', enabled: false, reason: 'ACCOUNT_REQUIRED'),
        PermittedActionEntity(actionType: 'assessment', enabled: false, reason: 'ACCOUNT_REQUIRED'),
      ],
      quickTips: [
        {
          'id': 'qt-1',
          'content': 'Write down your main point on paper before speaking. Having 3 bullet points lowers cognitive anxiety by 40%.',
          'order': 1,
        },
        {
          'id': 'qt-2',
          'content': 'Use the 3-second pause rule: Inhale slowly before answering any unexpected question.',
          'order': 2,
        },
      ],
      videoSolutions: [
        {
          'id': 'vid-1',
          'title': 'Mastering Meeting Participation in High-Stakes Settings',
          'durationSec': 240,
          'requiresRegistration': true,
        },
      ],
      assessments: [
        {
          'id': 'ass-1',
          'title': 'Communication & Decisiveness Assessment',
          'questionCount': 5,
          'requiresRegistration': true,
        },
      ],
    );
  }

  @override
  Future<List<ConcernPromptEntity>> getCuratedConcerns() async {
    try {
      final response = await dio.get<List<dynamic>>('/v1/problem-profile/concerns');
      if (response.data != null) {
        return response.data!
            .map((e) => ConcernPromptEntity.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback
    }

    return _mockConcerns.map((c) {
      return c.copyWith(isSelected: _userSelectedConcernIds.contains(c.id));
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getUserProblemProfile() async {
    try {
      final response = await dio.get<List<dynamic>>('/v1/problem-profile');
      if (response.data != null) {
        return response.data!.cast<Map<String, dynamic>>();
      }
    } catch (_) {
      // Fallback
    }

    return _userSelectedConcernIds.map((id) {
      final concern = _mockConcerns.firstWhere((c) => c.id == id, orElse: () => _mockConcerns.first);
      return {
        'id': 'upp-$id',
        'concernPromptId': id,
        'promptText': concern.promptText,
        'status': 'active',
        'priority': 1,
      };
    }).toList();
  }

  @override
  Future<Map<String, dynamic>> saveProblemProfile({
    required List<String> concernPromptIds,
    int priority = 1,
    bool consent = true,
  }) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/v1/problem-profile',
        data: {
          'concernPromptIds': concernPromptIds,
          'priority': priority,
          'consentFlags': {'discovery_personalisation': consent},
        },
      );
      if (response.data != null) {
        _userSelectedConcernIds
          ..clear()
          ..addAll(concernPromptIds);
        return response.data!;
      }
    } catch (_) {
      // Fallback
    }

    _userSelectedConcernIds
      ..clear()
      ..addAll(concernPromptIds);

    return {
      'message': 'Problem profile saved successfully',
      'activeConcernCount': concernPromptIds.length,
      'concerns': concernPromptIds.map((id) {
        final c = _mockConcerns.firstWhere((item) => item.id == id, orElse: () => _mockConcerns.first);
        return {'id': c.id, 'promptText': c.promptText};
      }).toList(),
    };
  }

  @override
  Future<Map<String, dynamic>> updateProblemProfile(
    String id, {
    String? status,
    int? priority,
  }) async {
    try {
      final response = await dio.patch<Map<String, dynamic>>(
        '/v1/problem-profile/$id',
        data: {
          if (status != null) 'status': status,
          if (priority != null) 'priority': priority,
        },
      );
      if (response.data != null) return response.data!;
    } catch (_) {
      // Fallback
    }

    return {
      'id': id,
      'status': status ?? 'active',
      'priority': priority ?? 1,
    };
  }

  @override
  Future<void> recordDiscoveryEvent({
    required String eventType,
    required String questionId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final guestRef = await guestStorage.getGuestRef();
      await dio.post(
        '/v1/discovery/events',
        data: {
          'eventType': eventType,
          'questionId': questionId,
          'metadata': metadata ?? {},
        },
        options: Options(headers: {
          if (guestRef != null) 'X-Guest-Ref': guestRef,
        }),
      );
    } catch (_) {
      // Silent error for telemetry
    }
  }
}

