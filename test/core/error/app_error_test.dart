import 'package:flutter_test/flutter_test.dart';
import 'package:conficircle/core/error/app_error.dart';
import 'package:conficircle/core/error/error_codes.dart';

void main() {
  group('AppError', () {
    test('fromJson correctly parses standard backend error envelope', () {
      final json = {
        'code': 'QUOTA_EXHAUSTED',
        'message': 'Your guest quota is exhausted',
        'requestId': 'req-987',
        'details': {'limit': 3},
      };

      final error = AppError.fromJson(json, statusCode: 429);

      expect(error.code, ErrorCode.quotaExhausted);
      expect(error.message, 'Your guest quota is exhausted');
      expect(error.requestId, 'req-987');
      expect(error.statusCode, 429);
      expect(error.details?['limit'], 3);
    });

    test('errorCodeFromString maps known and unknown error codes properly', () {
      expect(errorCodeFromString('ACCOUNT_REQUIRED'), ErrorCode.accountRequired);
      expect(errorCodeFromString('SESSION_EXPIRED'), ErrorCode.sessionExpired);
      expect(errorCodeFromString('FORBIDDEN'), ErrorCode.forbidden);
      expect(errorCodeFromString('NOT_FOUND'), ErrorCode.notFound);
      expect(errorCodeFromString('RATE_LIMITED'), ErrorCode.rateLimited);
      expect(errorCodeFromString('UNKNOWN_OR_NEW_CODE'), ErrorCode.unknown);
      expect(errorCodeFromString(null), ErrorCode.unknown);
    });

    test('toString formats error representation cleanly', () {
      const error = AppError(
        code: ErrorCode.sessionExpired,
        message: 'Session has ended',
      );
      expect(error.toString(), contains('AppError(ErrorCode.sessionExpired): Session has ended'));
    });
  });
}
