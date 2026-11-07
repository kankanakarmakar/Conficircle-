import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum ErrorCode {
  ACCOUNT_REQUIRED = 'ACCOUNT_REQUIRED',
  QUOTA_EXHAUSTED = 'QUOTA_EXHAUSTED',
  SESSION_EXPIRED = 'SESSION_EXPIRED',
  FORBIDDEN = 'FORBIDDEN',
  NOT_FOUND = 'NOT_FOUND',
  VALIDATION_FAILED = 'VALIDATION_FAILED',
  RATE_LIMITED = 'RATE_LIMITED',
  IDEMPOTENCY_CONFLICT = 'IDEMPOTENCY_CONFLICT',
  UNAUTHORIZED = 'UNAUTHORIZED',
  MIGRATION_FAILED = 'MIGRATION_FAILED',
  INTERNAL_ERROR = 'INTERNAL_ERROR',
}

export class ErrorResponseDto {
  @ApiProperty({ enum: ErrorCode, example: ErrorCode.ACCOUNT_REQUIRED })
  code!: ErrorCode | string;

  @ApiProperty({ example: 'This action requires a registered account' })
  message!: string;

  @ApiPropertyOptional({ example: { field: 'email', reason: 'Invalid format' } })
  details?: unknown;

  @ApiProperty({ example: 'req_123456789' })
  requestId!: string;
}
