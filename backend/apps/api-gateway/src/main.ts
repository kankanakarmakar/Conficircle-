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
  app.useGlobalFilters(app.get(GlobalExceptionFilter));

  // CORS — allowed origins come from CORS_ORIGINS (comma separated)
  app.enableCors({
    origin: corsOrigins(process.env),
    credentials: true,
    exposedHeaders: ["x-request-id"],
  });

  // Swagger documentation at /docs
  const docConfig = new DocumentBuilder()
    .setTitle("ConfCircle API Gateway")
    .setDescription(
      "Single external entry point for the ConfCircle Flutter app. " +
        "Routes to identity, content, assessment and progress services.",
    )
    .setVersion("0.1.0")
    .addBearerAuth()
    .build();
  SwaggerModule.setup("docs", app, SwaggerModule.createDocument(app, docConfig));

  app.enableShutdownHooks();
  await app.listen(config.port, "0.0.0.0");
  nestLogger.log(`api-gateway listening on port ${config.port}, swagger at /docs`);
}

void bootstrap().catch((err) => {
  nestLogger.error("Bootstrap failed", String(err));
  process.exit(1);
});
