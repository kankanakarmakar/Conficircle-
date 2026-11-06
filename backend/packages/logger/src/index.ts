/**
 * Structured JSON logger shared by all ConfCircle backend apps.
 * Emits single-line JSON so any log shipper can parse it.
 * NEVER pass secrets, tokens or passwords through metadata.
 */

export type LogLevel = "debug" | "info" | "warn" | "error";

const LEVEL_RANK: Record<LogLevel, number> = {
  debug: 10,
  info: 20,
  warn: 30,
  error: 40,
};

export interface LogFields {
  [key: string]: unknown;
}

export interface Logger {
  debug(message: string, fields?: LogFields): void;
  info(message: string, fields?: LogFields): void;
  warn(message: string, fields?: LogFields): void;
  error(message: string, fields?: LogFields): void;
}

/** Keys that must never be logged even if accidentally supplied. */
const REDACTED = new Set([
  "password",
  "secret",
  "accesstoken",
  "refreshtoken",
  "authorization",
  "token",
  "databaseurl",
]);

function sanitize(fields?: LogFields): LogFields | undefined {
  if (!fields) return undefined;
  const out: LogFields = {};
  for (const [key, value] of Object.entries(fields)) {
    out[REDACTED.has(key.toLowerCase()) ? "[REDACTED]" : key] = value;
  }
  return out;
}

export function createLogger(options: {
  service: string;
  level?: string;
}): Logger {
  const threshold = LEVEL_RANK[(options.level as LogLevel) ?? "info"] ?? 20;

  function emit(level: LogLevel, message: string, fields?: LogFields) {
    if (LEVEL_RANK[level] < threshold) return;
    const line = JSON.stringify({
      ts: new Date().toISOString(),
      level,
      service: options.service,
      message,
      ...sanitize(fields),
    });
    if (level === "error") process.stderr.write(line + "\n");
    else process.stdout.write(line + "\n");
  }

  return {
    debug: (m, f) => emit("debug", m, f),
    info: (m, f) => emit("info", m, f),
    warn: (m, f) => emit("warn", m, f),
    error: (m, f) => emit("error", m, f),
  };
}

/**
 * Adapter so the shared JSON logger can be handed to NestFactory as a
 * NestJS LoggerService (Nest expects log/warn/error/debug/verbose).
 */
export function asNestLoggerService(logger: Logger) {
  return {
    log: (m: string, ctx?: string) => logger.info(m, { ctx }),
    warn: (m: string, ctx?: string) => logger.warn(m, { ctx }),
    error: (m: string, ctx?: string) => logger.error(m, { ctx }),
    debug: (m: string, ctx?: string) => logger.debug(m, { ctx }),
    verbose: (m: string, ctx?: string) => logger.debug(m, { ctx, verbose: true }),
  };
}
