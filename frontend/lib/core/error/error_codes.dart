// lib/core/error/error_codes.dart

/// Typed error codes that mirror backend error envelope codes.
enum ErrorCode {
  accountRequired,
  quotaExhausted,
  sessionExpired,
  forbidden,
  notFound,
  validationFailed,
  rateLimited,
  idempotencyConflict,
  networkError,
  unknown,
}

/// Maps raw backend string codes to [ErrorCode] enum values.
ErrorCode errorCodeFromString(String? code) {
  switch (code) {
    case 'ACCOUNT_REQUIRED':
      return ErrorCode.accountRequired;
    case 'QUOTA_EXHAUSTED':
      return ErrorCode.quotaExhausted;
    case 'SESSION_EXPIRED':
      return ErrorCode.sessionExpired;
    case 'FORBIDDEN':
      return ErrorCode.forbidden;
    case 'NOT_FOUND':
      return ErrorCode.notFound;
    case 'VALIDATION_FAILED':
      return ErrorCode.validationFailed;
    case 'RATE_LIMITED':
      return ErrorCode.rateLimited;
    case 'IDEMPOTENCY_CONFLICT':
      return ErrorCode.idempotencyConflict;
    case 'NETWORK_ERROR':
      return ErrorCode.networkError;
    default:
      return ErrorCode.unknown;
  }
}
