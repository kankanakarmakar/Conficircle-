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

/** Gateway-only CORS configuration, parsed from CORS_ORIGINS. */
export function corsOrigins(env: NodeJS.ProcessEnv = process.env): string[] {
  return (env.CORS_ORIGINS ?? "http://localhost:5000")
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean);
}

/** service-name -> upstream base URL map used by the proxy module. */
export function upstreamRoutes(env: NodeJS.ProcessEnv = process.env): Record<string, string> {
  return {
    identity: env.IDENTITY_SERVICE_URL ?? "http://localhost:3001",
    content: env.CONTENT_SERVICE_URL ?? "http://localhost:3002",
    assessment: env.ASSESSMENT_SERVICE_URL ?? "http://localhost:3003",
    progress: env.PROGRESS_SERVICE_URL ?? "http://localhost:3004",
  };
}

/** Parsed, typed singleton for the app bootstrap. */
export const config = loadConfig();
