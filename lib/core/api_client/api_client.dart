// lib/core/api_client/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_storage.dart';
import '../guest/guest_storage.dart';
import 'auth_interceptor.dart';
import 'idempotency_interceptor.dart';
import 'error_interceptor.dart';

/// Resolves the optimal Base URL for the ConfCircle backend API.
/// - Prioritizes compile-time environment variable `API_URL`
/// - Web (localhost:8080) -> connects to `http://localhost:3000`
/// - Android emulator -> connects to `http://10.0.2.2:3000`
/// - Desktop / iOS Simulator -> connects to `http://localhost:3000`
/// - Production release default -> `https://api.conficircle.com`
String getBaseUrl() {
  const envUrl = String.fromEnvironment('API_URL');
  if (envUrl.isNotEmpty) {
    return envUrl;
  }
  if (kIsWeb) {
    return 'http://localhost:3000';
  }
  if (!kReleaseMode) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }
  return 'https://api.conficircle.com';
}

/// Creates and configures the [Dio] HTTP client with all interceptors.
Dio createDio({
  required AuthStorage authStorage,
  required GuestStorage guestStorage,
  required Ref ref,
  String? baseUrl,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? getBaseUrl(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(
      dio: dio,
      authStorage: authStorage,
      guestStorage: guestStorage,
      ref: ref,
    ),
    IdempotencyInterceptor(),
    ErrorInterceptor(),
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (o) => debugPrint(o.toString()),
    ),
  ]);

  return dio;
}

/// Riverpod provider that exposes the configured [Dio] instance.
final dioProvider = Provider<Dio>((ref) {
  return createDio(
    authStorage: ref.read(authStorageProvider),
    guestStorage: ref.read(guestStorageProvider),
    ref: ref,
  );
});

void debugPrint(String message) {
  // ignore: avoid_print
  print('[ConfCircle API] $message');
}
