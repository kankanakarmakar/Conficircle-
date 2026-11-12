// lib/core/api_client/error_interceptor.dart
import 'package:dio/dio.dart';
import '../error/app_error.dart';

/// Intercepts Dio responses and converts API error envelopes into [AppError].
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appError = AppError.fromDioError(err);
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appError,
        message: appError.message,
      ),
    );
  }
}
