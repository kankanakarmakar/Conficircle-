import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { ErrorCode, ErrorResponseDto } from '../dto/error.dto';

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(HttpExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const requestId = (request.headers['x-request-id'] as string) || (request as any).requestId || 'req_unknown';

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let code: ErrorCode | string = ErrorCode.INTERNAL_ERROR;
    let message = 'An unexpected internal error occurred';
    let details: unknown = undefined;

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const res = exception.getResponse();

      if (typeof res === 'string') {
        message = res;
      } else if (typeof res === 'object' && res !== null) {
        const obj = res as Record<string, any>;
        message = obj.message || exception.message;
        details = obj.details !== undefined ? obj.details : (Array.isArray(obj.message) ? obj.message : undefined);
        code = obj.code || this.mapStatusToErrorCode(status);
      }
    } else if (exception instanceof Error) {
      this.logger.error(`Unhandled Exception [${requestId}]: ${exception.message}`, exception.stack);
      message = exception.message;
    }

    const errorPayload: ErrorResponseDto = {
      code,
      message,
      ...(details !== undefined ? { details } : {}),
      requestId,
    };

    response.status(status).json(errorPayload);
  }

  private mapStatusToErrorCode(status: number): ErrorCode {
    switch (status) {
      case HttpStatus.UNAUTHORIZED:
        return ErrorCode.UNAUTHORIZED;
      case HttpStatus.FORBIDDEN:
        return ErrorCode.FORBIDDEN;
      case HttpStatus.NOT_FOUND:
        return ErrorCode.NOT_FOUND;
      case HttpStatus.BAD_REQUEST:
        return ErrorCode.VALIDATION_FAILED;
      case HttpStatus.TOO_MANY_REQUESTS:
        return ErrorCode.RATE_LIMITED;
      case HttpStatus.CONFLICT:
        return ErrorCode.IDEMPOTENCY_CONFLICT;
      default:
        return ErrorCode.INTERNAL_ERROR;
    }
  }
}

