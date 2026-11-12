// lib/features/guest/presentation/providers/guest_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api_client/api_client.dart';
import '../../../../core/guest/guest_storage.dart';
import '../../data/repositories/guest_repository.dart';
import '../../domain/entities/guest_session_entity.dart';
import '../../domain/use_cases/create_guest_session_use_case.dart';
import '../../domain/use_cases/get_guest_questions_use_case.dart';

final guestStorageProvider = Provider<GuestStorage>((ref) => GuestStorage());

final guestRepositoryProvider = Provider<GuestRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(guestStorageProvider);
  return GuestRepositoryImpl(dio: dio, guestStorage: storage);
});

final createGuestSessionUseCaseProvider = Provider<CreateGuestSessionUseCase>((ref) {
  final repo = ref.watch(guestRepositoryProvider);
  return CreateGuestSessionUseCase(repo);
});

final getGuestQuestionsUseCaseProvider = Provider<GetGuestQuestionsUseCase>((ref) {
  final repo = ref.watch(guestRepositoryProvider);
  return GetGuestQuestionsUseCase(repo);
});

class GuestState {
  const GuestState({
    this.session,
    this.questions = const [],
    this.isLoading = false,
    this.error,
  });

  final GuestSessionEntity? session;
  final List<Map<String, dynamic>> questions;
  final bool isLoading;
  final String? error;

  GuestState copyWith({
    GuestSessionEntity? session,
    List<Map<String, dynamic>>? questions,
    bool? isLoading,
    String? error,
  }) {
    return GuestState(
      session: session ?? this.session,
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class GuestNotifier extends StateNotifier<GuestState> {
  GuestNotifier(this._createSession, this._getQuestions) : super(const GuestState());

  final CreateGuestSessionUseCase _createSession;
  final GetGuestQuestionsUseCase _getQuestions;

  Future<void> initGuest() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _createSession();
      final questions = await _getQuestions();
      state = state.copyWith(session: session, questions: questions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final guestNotifierProvider = StateNotifierProvider<GuestNotifier, GuestState>((ref) {
  final createSession = ref.watch(createGuestSessionUseCaseProvider);
  final getQuestions = ref.watch(getGuestQuestionsUseCaseProvider);
  return GuestNotifier(createSession, getQuestions);
});

