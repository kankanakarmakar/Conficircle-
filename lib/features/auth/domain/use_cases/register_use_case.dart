// lib/features/auth/domain/use_cases/register_use_case.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mappers/auth_mapper.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/user_entity.dart';
import '../../../../core/auth/token_manager.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository, this._tokenManager);

  final AuthRepository _repository;
  final TokenManager _tokenManager;

  Future<UserEntity> execute({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final dto = await _repository.register(
      email: email,
      password: password,
      displayName: displayName,
    );
    await _tokenManager.saveTokens(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
    );
    return AuthMapper.toEntity(dto.user);
  }
}

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(
    ref.read(authRepositoryProvider),
    ref.read(tokenManagerProvider.notifier),
  );
});
