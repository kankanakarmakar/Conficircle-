// lib/features/guest/domain/use_cases/get_guest_questions_use_case.dart
import '../../data/repositories/guest_repository.dart';

class GetGuestQuestionsUseCase {
  const GetGuestQuestionsUseCase(this._repository);
  final GuestRepository _repository;

  Future<List<Map<String, dynamic>>> call() => _repository.getGuestQuestions();
}

