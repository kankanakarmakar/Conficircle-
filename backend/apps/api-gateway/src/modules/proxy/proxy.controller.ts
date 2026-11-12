/**
 * Thin HTTP proxy controller. This is routing, not business logic:
 * the gateway forwards prefixed requests (`/identity/**`, `/content/**`,
 * `/assessment/**`, `/progress/**`) to the matching upstream service and
 * relays the correlation ID header. Domain-level controllers will
 * replace this per feature; only the gateway exposes this entry point.
 */
import {
  All,
  Body,
  Controller,
  HttpCode,
  HttpException,
  HttpStatus,
  Inject,
  Logger,
  Param,
  Headers,
  Req,
  Get,
} from "@nestjs/common";
import type { Request } from "express";
import { ApiOperation, ApiTags } from "@nestjs/swagger";

export interface RelayConfig {
  [service: string]: string;
}

export const UPSTREAMS = Symbol("UPSTREAMS");

@ApiTags("routes")
@Controller()
export class ProxyController {
  private readonly logger = new Logger(ProxyController.name);

  constructor(@Inject(UPSTREAMS) private readonly relays: RelayConfig) {}

  @Get("routes")
  @ApiOperation({ summary: "List configured upstream routings (development aid)" })
  routes() {
    return { ...this.relays };
  }

  /** Relay `/:service/**` to the configured upstream service. */
  @All(":service/*path")
  @HttpCode(500)
  async relay(
    @Req() req: Request,
    @Param("service") service: string,
    @Body() body: unknown,
    @Headers("x-request-id") correlationId?: string,
  ) {
    const base = this.relays[service];
    if (!base) {
      throw new HttpException(`Unknown upstream service: ${service}`, HttpStatus.NOT_FOUND);
    }
    const upstreamPath = (req.originalUrl ?? req.url).replace(`/${service}`, "");
    const url = `${base}${upstreamPath}`;
    try {
      const res = await fetch(url, {
        method: req.method,
        headers: {
          "content-type": "application/json",
          ...(correlationId ? { "x-request-id": correlationId } : {}),
        },
        body: req.method === "GET" || body === undefined ? undefined : JSON.stringify(body),
      });
      return await res.json();
    } catch (err) {
      this.logger.error(`relay failed -> ${url}: ${String(err)}`);
      throw new HttpException(`Upstream ${service} unreachable`, HttpStatus.BAD_GATEWAY);
    }
  }
}
