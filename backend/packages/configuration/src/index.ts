/**
 * Shared configuration primitives: validated env value helpers and a
 * small DTO base used by per-service env validation. Services keep
 * their own config modules; @conficircle/configuration supplies the
 * shared validation vocabulary.
 */
import { IsIn, IsNumber, IsString, Min } from "class-validator";

export class BaseEnv {
  @IsIn(["development", "test", "production"])
  NODE_ENV: string = process.env.NODE_ENV ?? "development";

  @IsNumber()
  @Min(1)
  PORT: number = Number(process.env.PORT ?? 3000);

  @IsString()
  DATABASE_URL?: string = process.env.DATABASE_URL;

  @IsString()
  RABBITMQ_URL: string = process.env.RABBITMQ_URL ?? "";

  @IsString()
  REDIS_URL: string = process.env.REDIS_URL ?? "";

  @IsIn(["debug", "info", "warn", "error"])
  LOG_LEVEL: string = process.env.LOG_LEVEL ?? "info";
}

export const SECONDS = 1_000;
export const MINUTES = 60 * SECONDS;

/** Parses a comma-separated origins list for CORS configuration. */
export function parseOrigins(raw: string | undefined, fallback: string[]): string[] {
  if (!raw || !raw.trim()) return fallback;
  return raw.split(",").map((s) => s.trim()).filter(Boolean);
}
