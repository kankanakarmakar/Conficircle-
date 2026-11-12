import { NestFactory } from "@nestjs/core";
import { NestExpressApplication } from "@nestjs/platform-express";
import { ValidationPipe, Logger as NestLogger } from "@nestjs/common";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { corsOrigins, config } from "./config/config";
import { createLogger, asNestLoggerService } from "@conficircle/logger";
import { AppModule } from "./app.module";
import { GlobalExceptionFilter } from "./common/global-exception.filter";
import { CorrelationIdMiddleware } from "./common/correlation-id.middleware";
import type { Request, Response, NextFunction } from "express";

const nestLogger = new NestLogger("conficircle.api-gateway");

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    logger: asNestLoggerService(
      createLogger({ service: "api-gateway", level: config.logLevel }),
    ),
  });

  // Request correlation IDs
  app.use((req: Request, res: Response, next: NextFunction) =>
    new CorrelationIdMiddleware().use(req, res, next),
  );

  // Global input validation
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Global exception handling (structured JSON, no stack traces)
  app.useGlobalFilters(new GlobalExceptionFilter());

  // CORS — allowed origins come from CORS_ORIGINS (comma separated)
  app.enableCors({
    origin: corsOrigins(process.env),
    credentials: true,
    exposedHeaders: ["x-request-id"],
  });

  // Swagger documentation at /docs
  const docConfig = new DocumentBuilder()
    .setTitle("ConfCircle API Gateway & Mobile Backend")
    .setDescription(
      "Comprehensive REST API foundation for the ConfCircle Flutter mobile & web client. " +
        "Covers Authentication, Guest Sessions & Quotas, Level 4 Discovery & Shuffling, " +
        "Questions & Micro-Coaching Tips, Problem Profiles, Content Curriculum, and Assessments.",
    )
    .setVersion("1.0.0")
    .addBearerAuth(
      {
        type: "http",
        scheme: "bearer",
        bearerFormat: "JWT",
        name: "JWT",
        description: "Enter your Bearer access token",
        in: "header",
      },
      "bearer",
    )
    .addTag("Auth", "Registration, login, JWT token rotation, and profile management")
    .addTag("Guest", "Anonymous guest device registration and quota management")
    .addTag("QuickTips", "Micro-coaching tips with idempotency guards and guest quota deductions")
    .addTag("Discovery", "Level 4 catalog discovery, shuffle batches, and telemetry events")
    .addTag("Questions", "Question details, video teasers, and action eligibility")
    .addTag("ProblemProfile", "Curated concern selection and personalization preferences")
    .addTag("Content", "Topics, video lessons, curriculum, and downloadable resources")
    .addTag("Assessment", "Self-assessments, scoring evaluations, and level certification")
    .addTag("Progress", "Learning streaks, video progress heartbeats, and Confy points ledger")
    .addTag("Health", "Service health check and diagnostic status")
    .build();

  const document = SwaggerModule.createDocument(app, docConfig);
  SwaggerModule.setup("docs", app, document, {
    customSiteTitle: "ConfCircle API Docs",
    swaggerOptions: {
      persistAuthorization: true,
      displayRequestDuration: true,
      filter: true,
    },
  });

  app.enableShutdownHooks();
  await app.listen(config.port, "0.0.0.0");
  nestLogger.log(`api-gateway listening on port ${config.port}, swagger at /docs`);
}

void bootstrap().catch((err) => {
  nestLogger.error("Bootstrap failed", String(err));
  process.exit(1);
});
