// lib/features/guest/domain/use_cases/create_guest_session_use_case.dart
import '../../data/repositories/guest_repository.dart';
import '../entities/guest_session_entity.dart';

class CreateGuestSessionUseCase {
  const CreateGuestSessionUseCase(this._repository);
  final GuestRepository _repository;

  Future<GuestSessionEntity> call() => _repository.getOrCreateSession();
}

