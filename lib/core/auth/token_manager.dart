// lib/core/auth/token_manager.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_storage.dart';

/// Represents the authentication state of the token lifecycle.
enum TokenState { loading, authenticated, unauthenticated }

/// Manages access and refresh token lifecycle.
///
/// Responsibilities:
/// - Persist and retrieve tokens via [AuthStorage].
/// - Expose current [TokenState] to the app.
/// - Provide methods for token refresh and logout.
class TokenManager extends AsyncNotifier<TokenState> {
  late AuthStorage _authStorage;

  @override
  Future<TokenState> build() async {
    _authStorage = ref.read(authStorageProvider);
    final accessToken = await _authStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      return TokenState.authenticated;
    }
    return TokenState.unauthenticated;
  }

  /// Saves a new pair of tokens and transitions to authenticated.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _authStorage.saveAccessToken(accessToken);
    await _authStorage.saveRefreshToken(refreshToken);
    state = const AsyncData(TokenState.authenticated);
  }

  /// Clears all tokens and transitions to unauthenticated.
  Future<void> clearTokens() async {
    await _authStorage.clearAll();
    state = const AsyncData(TokenState.unauthenticated);
  }

  /// Attempts a token refresh using the stored refresh token.
  ///
  /// Returns true if the refresh succeeded, false otherwise.
  Future<bool> tryRefresh(
    Future<Map<String, String>> Function(String refreshToken) refreshCall,
  ) async {
    final refreshToken = await _authStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await clearTokens();
      return false;
    }
    try {
      final tokens = await refreshCall(refreshToken);
      final newAccess = tokens['accessToken'];
      final newRefresh = tokens['refreshToken'];
      if (newAccess != null && newRefresh != null) {
        await saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh,
        );
        return true;
      }
      await clearTokens();
      return false;
    } catch (_) {
      await clearTokens();
      return false;
    }
  }
}

/// Riverpod provider for [TokenManager].
final tokenManagerProvider =
    AsyncNotifierProvider<TokenManager, TokenState>(TokenManager.new);
