import { NestFactory } from "@nestjs/core";
import { NestExpressApplication } from "@nestjs/platform-express";
import { ValidationPipe, Logger as NestLogger } from "@nestjs/common";
import { config } from "./config/config";
import { createLogger, asNestLoggerService } from "@conficircle/logger";
import { AppModule } from "./app.module";

const nestLogger = new NestLogger("conficircle.progress-service");

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    logger: asNestLoggerService(
      createLogger({ service: "progress-service", level: config.logLevel }),
    ),
  });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  app.enableShutdownHooks();

  await app.listen(config.port, "0.0.0.0");
  nestLogger.log(`conficircle.progress-service listening on port ${config.port}`);
}

void bootstrap().catch((err) => {
  nestLogger.error("Bootstrap failed", String(err));
  process.exit(1);
});
