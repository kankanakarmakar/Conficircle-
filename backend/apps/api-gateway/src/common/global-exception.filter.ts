import { ExceptionFilter, Catch, ArgumentsHost, HttpException, HttpStatus, Logger } from "@nestjs/common";
import type { Request, Response } from "express";

/**
 * Global catch-all exception handler: structured JSON output with the
 * request correlation ID, no stack traces in responses, no sensitive
 * fields in messages.
 */
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger("GlobalExceptionFilter");

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    const status =
      exception instanceof HttpException ? exception.getStatus() : HttpStatus.INTERNAL_SERVER_ERROR;

    const correlationId = (request as unknown as { correlationId?: string }).correlationId;

    if (status >= 500) {
      this.logger.error(`${request.method} ${request.url}: ${String(exception)}`, correlationId);
    }

    response.status(status).json({
      statusCode: status,
      path: request.url,
      timestamp: new Date().toISOString(),
      correlationId,
      message:
        status >= 500
          ? "Internal server error"
          : exception instanceof HttpException
            ? exception.message
            : "Error",
    });
  }
}
