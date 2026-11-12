// lib/features/auth/data/repositories/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api_client/api_client.dart';
import '../../../../core/error/app_error.dart';
import '../dtos/auth_dto.dart';

/// Repository for all `/v1/auth/*` API calls.
class AuthRepository {
  const AuthRepository(this._dio);

  final Dio _dio;

  /// POST /v1/auth/login
  Future<AuthResponseDto> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/auth/login',
        data: LoginRequestDto(email: email, password: password).toJson(),
      );
      return AuthResponseDto.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is AppError ? e.error as AppError : AppError.fromDioError(e);
    }
  }

  /// POST /v1/auth/register
  Future<AuthResponseDto> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/auth/register',
        data: RegisterRequestDto(
          email: email,
          password: password,
          displayName: displayName,
        ).toJson(),
      );
      return AuthResponseDto.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is AppError ? e.error as AppError : AppError.fromDioError(e);
    }
  }

  /// POST /v1/auth/refresh
  Future<AuthResponseDto> refresh({required String refreshToken}) async {
    try {
      final response = await _dio.post(
        '/v1/auth/refresh',
        data: RefreshRequestDto(refreshToken: refreshToken).toJson(),
      );
      return AuthResponseDto.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is AppError ? e.error as AppError : AppError.fromDioError(e);
    }
  }

  /// POST /v1/auth/logout
  Future<void> logout() async {
    try {
      await _dio.post('/v1/auth/logout');
    } on DioException catch (e) {
      throw e.error is AppError ? e.error as AppError : AppError.fromDioError(e);
    }
  }
}

/// Riverpod provider for [AuthRepository].
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(dioProvider));
});
