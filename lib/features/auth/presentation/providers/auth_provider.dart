// lib/features/auth/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/register_use_case.dart';
import '../../../../core/auth/token_manager.dart';
import '../../../../core/error/app_error.dart';
import '../../data/repositories/auth_repository.dart';

/// Riverpod notifier that manages auth state (login/register/logout).
class AuthNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    // No user loaded at start — splash handles initial auth check.
    return null;
  }

  /// Attempts to log in with [email] and [password].
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(loginUseCaseProvider);
      return useCase.execute(email: email, password: password);
    });
  }

  /// Registers a new account.
  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(registerUseCaseProvider);
      return useCase.execute(
        email: email,
        password: password,
        displayName: displayName,
      );
    });
  }

  /// Logs out the current user.
  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } on AppError {
      // Ignore logout API errors — clear locally regardless.
    }
    await ref.read(tokenManagerProvider.notifier).clearTokens();
    state = const AsyncData(null);
  }
}

/// Riverpod provider for [AuthNotifier].
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserEntity?>(AuthNotifier.new);
