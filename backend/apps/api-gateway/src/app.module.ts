import { Module } from "@nestjs/common";
import { APP_FILTER, APP_GUARD } from "@nestjs/core";
import { ThrottlerGuard, ThrottlerModule } from "@nestjs/throttler";
import { config, upstreamRoutes } from "./config/config";
import { HealthModule } from "./health/health.module";
import { PublisherModule } from "./messaging/publisher/publisher.module";
import { ConsumerModule } from "./messaging/consumer/consumer.module";
import { RabbitModule } from "./messaging/rabbit.module";
import { RabbitMQService } from "./messaging/rabbitmq.service";
import { ProxyController, UPSTREAMS } from "./modules/proxy/proxy.controller";
import { JwtAuthGuard } from "./common/jwt-auth.guard";
import { GlobalExceptionFilter } from "./common/global-exception.filter";

// Feature modules laying down the API foundation for Flutter & web clients
import { AuthModule } from "./modules/auth/auth.module";
import { GuestModule } from "./modules/guest/guest.module";
import { QuicktipsModule } from "./modules/quicktips/quicktips.module";
import { DiscoveryModule } from "./modules/discovery/discovery.module";
import { QuestionsModule } from "./modules/questions/questions.module";
import { ProblemProfileModule } from "./modules/problem-profile/problem-profile.module";
import { ContentModule } from "./modules/content/content.module";
import { AssessmentModule } from "./modules/assessment/assessment.module";
import { ProgressModule } from "./modules/progress/progress.module";

const rabbitService = new RabbitMQService(config.rabbitUrl, "conficircle.api-gateway", config.logLevel);

const throttlerModule = ThrottlerModule.forRoot([
  {
    name: "default",
    ttl: 60_000, // 1 minute window
    limit: Number(process.env.GATEWAY_RATE_LIMIT ?? 120),
  },
]);

@Module({
  imports: [
    throttlerModule,
    HealthModule,
    PublisherModule,
    ConsumerModule,
    RabbitModule.forRoot(rabbitService),
    // Core Domain API Foundations
    AuthModule,
    GuestModule,
    QuicktipsModule,
    DiscoveryModule,
    QuestionsModule,
    ProblemProfileModule,
    ContentModule,
    AssessmentModule,
    ProgressModule,
  ],
  controllers: [ProxyController],
  providers: [
    { provide: UPSTREAMS, useValue: upstreamRoutes() },
    // Authentication guard runs first: validates/attaches the request user.
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    // Endpoint-level rate limiting
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    // Global exception handling
    { provide: APP_FILTER, useClass: GlobalExceptionFilter },
  ],
})
export class AppModule {}
