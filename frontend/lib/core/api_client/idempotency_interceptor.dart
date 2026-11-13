// lib/core/api_client/idempotency_interceptor.dart
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

const _idempotencyHeader = 'Idempotency-Key';
const _mutatingMethods = {'POST', 'PUT', 'PATCH', 'DELETE'};

/// Automatically adds an `Idempotency-Key` UUID header to mutating requests.
class IdempotencyInterceptor extends Interceptor {
  IdempotencyInterceptor() : _uuid = const Uuid();

  final Uuid _uuid;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (_mutatingMethods.contains(options.method.toUpperCase())) {
      options.headers[_idempotencyHeader] = _uuid.v4();
    }
    handler.next(options);
  }
}
