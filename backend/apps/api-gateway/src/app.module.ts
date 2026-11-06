import { Module } from "@nestjs/common";
import { APP_FILTER, APP_GUARD } from "@nestjs/core";
import { ThrottlerGuard, ThrottlerModule } from "@nestjs/throttler";
import { config } from "./config/config";
import { HealthModule } from "./health/health.module";
import { PublisherModule } from "./messaging/publisher/publisher.module";
import { ConsumerModule } from "./messaging/consumer/consumer.module";
import { RabbitModule } from "./messaging/rabbit.module";
import { RabbitMQService } from "./messaging/rabbitmq.service";
import { ProxyController, UPSTREAMS } from "./modules/proxy/proxy.controller";
import { upstreamRoutes } from "./config/config";
import { JwtAuthGuard } from "./common/jwt-auth.guard";
import { GlobalExceptionFilter } from "./common/global-exception.filter";

const rabbitService = new RabbitMQService(config.rabbitUrl, "conficircle.api-gateway", config.logLevel);

const throttlerModule = ThrottlerModule.forRoot([
  {
    name: "default",
    ttl: 60_000, // 1 minute window
    limit: Number(process.env.GATEWAY_RATE_LIMIT ?? 120),
  },
]);

@Module({
  imports: [throttlerModule, HealthModule, PublisherModule, ConsumerModule, RabbitModule.forRoot(rabbitService)],
  controllers: [ProxyController],
  providers: [
    { provide: UPSTREAMS, useValue: upstreamRoutes() },
    // Authentication guard runs first: validates/attaches the request user.
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    // Endpoint-level rate limiting (endpoint-specific overrides land with real endpoints).
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    // Global exception handling.
    { provide: APP_FILTER, useClass: GlobalExceptionFilter },
  ],
})
export class AppModule {}
