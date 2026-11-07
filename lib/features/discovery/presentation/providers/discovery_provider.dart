// lib/features/discovery/presentation/providers/discovery_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api_client/api_client.dart';
import '../../../../core/guest/guest_storage.dart';
import '../../data/repositories/discovery_repository.dart';
import '../../domain/entities/question_prompt_entity.dart';
import '../../domain/entities/discovery_batch_entity.dart';

// ── Repository Provider ────────────────────────────────────────────────────
final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final guestStorage = ref.watch(guestStorageProvider);
  return DiscoveryRepositoryImpl(dio: dio, guestStorage: guestStorage);
});

// ── Discovery Batch State (Immutable) ──────────────────────────────────────
class DiscoveryBatchState {
  final String batchId;
  final List<QuestionPromptEntity> items;
  final bool isLoading;
  final bool isShuffling;
  final String? error;
  final String? previousBatchId;
  final String audience;

  const DiscoveryBatchState({
    this.batchId = '',
    this.items = const [],
    this.isLoading = false,
    this.isShuffling = false,
    this.error,
    this.previousBatchId,
    this.audience = 'guest',
  });

  DiscoveryBatchState copyWith({
    String? batchId,
    List<QuestionPromptEntity>? items,
    bool? isLoading,
    bool? isShuffling,
    String? error,
    bool clearError = false,
    String? previousBatchId,
    String? audience,
  }) {
    return DiscoveryBatchState(
      batchId: batchId ?? this.batchId,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isShuffling: isShuffling ?? this.isShuffling,
      error: clearError ? null : (error ?? this.error),
      previousBatchId: previousBatchId ?? this.previousBatchId,
      audience: audience ?? this.audience,
    );
  }
}

// ── Discovery Notifier (Guest) ─────────────────────────────────────────────
class GuestDiscoveryNotifier extends StateNotifier<DiscoveryBatchState> {
  final DiscoveryRepository _repository;

  GuestDiscoveryNotifier(this._repository)
      : super(const DiscoveryBatchState(audience: 'guest'));

  Future<void> loadBatch({int limit = 8}) async {
    final batchSize = limit.clamp(7, 8);
    state = state.copyWith(isLoading: state.items.isEmpty, clearError: true);
    try {
      final batch = await _repository.getGuestQuestionBatch(
        limit: batchSize,
        previousBatchId: state.batchId.isNotEmpty ? state.batchId : null,
      );
      state = state.copyWith(
        batchId: batch.batchId,
        items: batch.items,
        isLoading: false,
        isShuffling: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> shuffle() async {
    // Immutable rule: Current cards remain visible during shuffle!
    state = state.copyWith(isShuffling: true, clearError: true);
    try {
      final batch = await _repository.shuffleGuestQuestionBatch(
        previousBatchId: state.batchId,
        excludedIds: state.items.map((i) => i.questionId).toList(),
      );
      // Replace only after successful response
      state = state.copyWith(
        previousBatchId: state.batchId,
        batchId: batch.batchId,
        items: batch.items,
        isShuffling: false,
        clearError: true,
      );
    } catch (e) {
      // On failure, keep current cards visible!
      state = state.copyWith(
        isShuffling: false,
        error: 'Failed to shuffle questions. Showing current set.',
      );
    }
  }

  void recordSelection(String questionId) {
    _repository.recordDiscoveryEvent(
      eventType: 'selection',
      questionId: questionId,
      metadata: {'batchId': state.batchId, 'audience': 'guest'},
    );
  }
}

final guestDiscoveryProvider =
    StateNotifierProvider<GuestDiscoveryNotifier, DiscoveryBatchState>((ref) {
  final repo = ref.watch(discoveryRepositoryProvider);
  return GuestDiscoveryNotifier(repo);
});

// ── Discovery Notifier (Registered) ────────────────────────────────────────
class RegisteredDiscoveryNotifier extends StateNotifier<DiscoveryBatchState> {
  final DiscoveryRepository _repository;

  RegisteredDiscoveryNotifier(this._repository)
      : super(const DiscoveryBatchState(audience: 'registered'));

  Future<void> loadBatch({int limit = 6}) async {
    final batchSize = limit.clamp(5, 6);
    state = state.copyWith(isLoading: state.items.isEmpty, clearError: true);
    try {
      final batch = await _repository.getRegisteredQuestionBatch(limit: batchSize);
      state = state.copyWith(
        batchId: batch.batchId,
        items: batch.items,
        isLoading: false,
        isShuffling: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> shuffle() async {
    // Current cards remain visible during shuffle
    state = state.copyWith(isShuffling: true, clearError: true);
    try {
      final batch = await _repository.shuffleRegisteredQuestionBatch(
        previousBatchId: state.batchId,
        excludedIds: state.items.map((i) => i.questionId).toList(),
      );
      state = state.copyWith(
        previousBatchId: state.batchId,
        batchId: batch.batchId,
        items: batch.items,
        isShuffling: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isShuffling: false,
        error: 'Failed to shuffle questions. Showing current set.',
      );
    }
  }

  void recordSelection(String questionId) {
    _repository.recordDiscoveryEvent(
      eventType: 'selection',
      questionId: questionId,
      metadata: {'batchId': state.batchId, 'audience': 'registered'},
    );
  }
}

final registeredDiscoveryProvider =
    StateNotifierProvider<RegisteredDiscoveryNotifier, DiscoveryBatchState>((ref) {
  final repo = ref.watch(discoveryRepositoryProvider);
  return RegisteredDiscoveryNotifier(repo);
});

