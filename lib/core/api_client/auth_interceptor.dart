// lib/core/api_client/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_storage.dart';
import '../auth/token_manager.dart';
import '../guest/guest_storage.dart';

/// Injects authorization headers and handles 401 refresh flow.
///
/// Priority:
///   1. If an access token exists → `Authorization: Bearer {token}`
///   2. Else if a guest ref exists → `X-Guest-Ref: {guestRef}`
///   3. On 401 → try refresh once, retry; on failure clear tokens.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.dio,
    required this.authStorage,
    required this.guestStorage,
    required this.ref,
  });

  final Dio dio;
  final AuthStorage authStorage;
  final GuestStorage guestStorage;
  final Ref ref;

  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await authStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      final guestRef = await guestStorage.getGuestRef();
      if (guestRef != null && guestRef.isNotEmpty) {
        options.headers['X-Guest-Ref'] = guestRef;
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      final tokenManager = ref.read(tokenManagerProvider.notifier);

      final refreshed = await tokenManager.tryRefresh((refreshToken) async {
        final response = await Dio().post(
          '${dio.options.baseUrl}/v1/auth/refresh',
          data: {'refreshToken': refreshToken},
        );
        return {
          'accessToken': response.data['accessToken'] as String,
          'refreshToken': response.data['refreshToken'] as String,
        };
      });

      _isRefreshing = false;

      if (refreshed) {
        // Retry the original request with the new token.
        final newToken = await authStorage.getAccessToken();
        final retryOptions = err.requestOptions
          ..headers['Authorization'] = 'Bearer $newToken';
        try {
          final retryResponse = await dio.fetch(retryOptions);
          handler.resolve(retryResponse);
          return;
        } catch (e) {
          handler.next(err);
          return;
        }
      }
      // Refresh failed — tokens cleared by tokenManager.
    }
    handler.next(err);
  }
}
