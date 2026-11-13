// lib/features/auth/domain/use_cases/refresh_session_use_case.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/auth/auth_storage.dart';
import '../../../../core/auth/token_manager.dart';

class RefreshSessionUseCase {
  const RefreshSessionUseCase(
    this._repository,
    this._authStorage,
    this._tokenManager,
  );

  final AuthRepository _repository;
  final AuthStorage _authStorage;
  final TokenManager _tokenManager;

  Future<bool> execute() async {
    final refreshToken = await _authStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;
    try {
      final dto = await _repository.refresh(refreshToken: refreshToken);
      await _tokenManager.saveTokens(
        accessToken: dto.accessToken,
        refreshToken: dto.refreshToken,
      );
      return true;
    } catch (_) {
      await _tokenManager.clearTokens();
      return false;
    }
  }
}

final refreshSessionUseCaseProvider = Provider<RefreshSessionUseCase>((ref) {
  return RefreshSessionUseCase(
    ref.read(authRepositoryProvider),
    ref.read(authStorageProvider),
    ref.read(tokenManagerProvider.notifier),
  );
});
