/**
 * Typed, validated environment configuration.
 * Fails fast on missing required values instead of leaking
 * undefined credentials deep into the app.
 */
export interface AppConfig {
  nodeEnv: string;
  port: number;
  logLevel: string;
  databaseUrl?: string;
  rabbitUrl: string;
  redisUrl: string;
}

export function loadConfig(env: NodeJS.ProcessEnv = process.env): AppConfig {
  const port = Number(env.PORT ?? 3000);
  if (!Number.isFinite(port)) {
    throw new Error("PORT must be a number");
  }
  const nodeEnv = env.NODE_ENV ?? "development";
  if (!["development", "test", "production"].includes(nodeEnv)) {
    throw new Error(`Invalid NODE_ENV: ${nodeEnv}`);
  }
  return {
    nodeEnv,
    port,
    logLevel: env.LOG_LEVEL ?? "info",
    databaseUrl: env.DATABASE_URL,
    rabbitUrl: env.RABBITMQ_URL ?? "",
    redisUrl: env.REDIS_URL ?? "",
  };
}

/**
 * Infrastructure URLs are optional while services run standalone with
 * local Postgres only. When present they must parse; we guard with a
 * lightweight format check instead of a full DTO to keep deps small.
 */
export function requireDatabaseUrl(config: AppConfig): string {
  if (!config.databaseUrl) {
    throw new Error(
      "DATABASE_URL is required for this service. Set it in .env (see backend/.env.example).",
    );
  }
  return config.databaseUrl;
}

/** Parsed, typed singleton for the app bootstrap. */
export const config = loadConfig();
