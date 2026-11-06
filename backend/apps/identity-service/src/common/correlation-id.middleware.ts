import { Injectable, NestMiddleware } from "@nestjs/common";
import type { NextFunction, Request, Response } from "express";
import { randomUUID } from "crypto";

/**
 * Attaches a correlation ID to every request: read the inbound
 * `x-request-id` header (set by the gateway or proxy) or generate a
 * UUID, and echo it back in the response header.
 */
@Injectable()
export class CorrelationIdMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    const correlationId =
      (req.headers["x-request-id"] as string | undefined) ?? randomUUID();
    (req as unknown as { correlationId: string }).correlationId = correlationId;
    res.setHeader("x-request-id", correlationId);
    next();
  }
}
