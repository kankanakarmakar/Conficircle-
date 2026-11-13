// test/features/discovery/discovery_batch_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:conficircle/features/discovery/domain/entities/question_prompt_entity.dart';
import 'package:conficircle/features/discovery/domain/entities/discovery_batch_entity.dart';
import 'package:conficircle/features/discovery/presentation/providers/discovery_provider.dart';
import 'package:conficircle/features/discovery/data/repositories/discovery_repository.dart';

class MockDiscoveryRepo implements DiscoveryRepository {
  bool shouldFailShuffle = false;

  @override
  Future<DiscoveryBatchEntity> getGuestQuestionBatch({int limit = 8, String? previousBatchId}) async {
    final batchSize = limit.clamp(7, 8);
    final items = List.generate(
      batchSize,
      (i) => QuestionPromptEntity(
        questionId: 'guest-q-$i',
        prompt: 'Guest Level 4 question prompt $i?',
        shortDescription: 'Helper description $i',
      ),
    );
    return DiscoveryBatchEntity(batchId: 'guest-batch-1', audience: 'guest', items: items);
  }

  @override
  Future<DiscoveryBatchEntity> shuffleGuestQuestionBatch({required String previousBatchId, List<String>? excludedIds}) async {
    if (shouldFailShuffle) {
      throw Exception('Network timeout during shuffle');
    }
    final items = List.generate(
      8,
      (i) => QuestionPromptEntity(
        questionId: 'guest-fresh-q-$i',
        prompt: 'Fresh guest Level 4 question prompt $i?',
      ),
    );
    return DiscoveryBatchEntity(batchId: 'guest-batch-2', audience: 'guest', items: items);
  }

  @override
  Future<DiscoveryBatchEntity> getRegisteredQuestionBatch({int limit = 6, String? context}) async {
    final batchSize = limit.clamp(5, 6);
    final items = List.generate(
      batchSize,
      (i) => QuestionPromptEntity(
        questionId: 'reg-q-$i',
        prompt: 'Registered Level 4 question prompt $i?',
        safeReasonLabel: i == 0 ? 'Based on what you selected' : null,
      ),
    );
    return DiscoveryBatchEntity(batchId: 'reg-batch-1', audience: 'registered', items: items);
  }

  @override
  Future<DiscoveryBatchEntity> shuffleRegisteredQuestionBatch({required String previousBatchId, List<String>? excludedIds}) async {
    if (shouldFailShuffle) {
      throw Exception('Network timeout during shuffle');
    }
    final items = List.generate(
      6,
      (i) => QuestionPromptEntity(
        questionId: 'reg-fresh-q-$i',
        prompt: 'Fresh registered Level 4 question prompt $i?',
      ),
    );
    return DiscoveryBatchEntity(batchId: 'reg-batch-2', audience: 'registered', items: items);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Discovery Batch Rules (Spec v3.0)', () {
    late MockDiscoveryRepo repo;

    setUp(() {
      repo = MockDiscoveryRepo();
    });

    test('Guest discovery batch returns 7-8 Level 4 questions (default: 8)', () async {
      final notifier = GuestDiscoveryNotifier(repo);
      await notifier.loadBatch();

      expect(notifier.state.audience, 'guest');
      expect(notifier.state.items.length, 8);
      expect(notifier.state.items.first.prompt, contains('Level 4 question prompt'));
    });

    test('Guest discovery batch respects 7 items limit', () async {
      final notifier = GuestDiscoveryNotifier(repo);
      await notifier.loadBatch(limit: 7);

      expect(notifier.state.items.length, 7);
    });

    test('Registered discovery batch returns 5-6 Level 4 questions (default: 6)', () async {
      final notifier = RegisteredDiscoveryNotifier(repo);
      await notifier.loadBatch();

      expect(notifier.state.audience, 'registered');
      expect(notifier.state.items.length, 6);
      expect(notifier.state.items.first.safeReasonLabel, 'Based on what you selected');
    });

    test('Registered discovery batch respects 5 items limit', () async {
      final notifier = RegisteredDiscoveryNotifier(repo);
      await notifier.loadBatch(limit: 5);

      expect(notifier.state.items.length, 5);
    });

    test('Shuffle preserves visible cards when request fails (immutable batch state)', () async {
      final notifier = GuestDiscoveryNotifier(repo);
      await notifier.loadBatch();
      final initialQuestions = notifier.state.items;
      expect(initialQuestions.length, 8);

      // Simulate failure
      repo.shouldFailShuffle = true;
      await notifier.shuffle();

      // Current cards MUST remain visible!
      expect(notifier.state.items.length, 8);
      expect(notifier.state.items, equals(initialQuestions));
      expect(notifier.state.error, isNotNull);
      expect(notifier.state.isShuffling, isFalse);
    });

    test('Shuffle replaces cards with fresh batch on success', () async {
      final notifier = RegisteredDiscoveryNotifier(repo);
      await notifier.loadBatch();
      expect(notifier.state.batchId, 'reg-batch-1');

      await notifier.shuffle();
      expect(notifier.state.batchId, 'reg-batch-2');
      expect(notifier.state.items.first.questionId, 'reg-fresh-q-0');
      expect(notifier.state.error, isNull);
    });
  });
}
