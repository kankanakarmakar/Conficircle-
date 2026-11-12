// lib/core/error/app_error.dart
import 'package:dio/dio.dart';
import 'error_codes.dart';

/// Typed application error that wraps backend error envelopes and Dio errors.
class AppError implements Exception {
  final ErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  final String? requestId;
  final int? statusCode;

  const AppError({
    required this.code,
    required this.message,
    this.details,
    this.requestId,
    this.statusCode,
  });

  /// Parses a backend error envelope: `{code, message, details?, requestId?}`.
  factory AppError.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    return AppError(
      code: errorCodeFromString(json['code'] as String?),
      message: (json['message'] as String?) ?? 'An unexpected error occurred.',
      details: json['details'] as Map<String, dynamic>?,
      requestId: json['requestId'] as String?,
      statusCode: statusCode,
    );
  }

  /// Converts a [DioException] to a typed [AppError].
  factory AppError.fromDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return AppError(
        code: ErrorCode.networkError,
        message: 'Network error. Please check your connection and try again.',
        statusCode: null,
      );
    }

    final response = error.response;
    if (response != null) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return AppError.fromJson(data, statusCode: response.statusCode);
      }
      return AppError(
        code: _codeFromStatus(response.statusCode),
        message: 'Server error (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }

    return const AppError(
      code: ErrorCode.unknown,
      message: 'An unexpected error occurred.',
    );
  }

  static ErrorCode _codeFromStatus(int? status) {
    switch (status) {
      case 401:
        return ErrorCode.sessionExpired;
      case 403:
        return ErrorCode.forbidden;
      case 404:
        return ErrorCode.notFound;
      case 409:
        return ErrorCode.idempotencyConflict;
      case 422:
        return ErrorCode.validationFailed;
      case 429:
        return ErrorCode.rateLimited;
      default:
        return ErrorCode.unknown;
    }
  }

  @override
  String toString() => 'AppError($code): $message';
}
