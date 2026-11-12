// lib/features/auth/domain/use_cases/login_use_case.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mappers/auth_mapper.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/user_entity.dart';
import '../../../../core/auth/token_manager.dart';

class LoginUseCase {
  const LoginUseCase(this._repository, this._tokenManager);

  final AuthRepository _repository;
  final TokenManager _tokenManager;

  Future<UserEntity> execute({
    required String email,
    required String password,
  }) async {
    final dto = await _repository.login(email: email, password: password);
    await _tokenManager.saveTokens(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
    );
    return AuthMapper.toEntity(dto.user);
  }
}

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(
    ref.read(authRepositoryProvider),
    ref.read(tokenManagerProvider.notifier),
  );
});
