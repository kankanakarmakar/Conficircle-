import { Injectable, OnModuleDestroy, OnModuleInit, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Redis from 'ioredis';

// Lua script: atomic quota check + decrement for guest quick tips
// Keys[1] = session key, Keys[2] = quota key, Keys[3] = idempotency key
// ARGV[1] = idem response JSON, ARGV[2] = idem TTL seconds
// Returns: ["ok", remaining] | ["quota_exhausted"] | ["session_expired"] | ["idem", cachedResponse]
const QUOTA_CHECK_LUA = `
local session = redis.call("EXISTS", KEYS[1])
if session == 0 then
  return {"session_expired"}
end

local idem = redis.call("GET", KEYS[3])
if idem ~= false then
  return {"idem", idem}
end

local quota = redis.call("GET", KEYS[2])
if quota == false then
  return {"quota_exhausted"}
end

local q = tonumber(quota)
if q <= 0 then
  return {"quota_exhausted"}
end

local remaining = redis.call("DECR", KEYS[2])
return {"ok", tostring(remaining)}
`;

// Lua script: store idempotency result
// Keys[1] = idempotency key, ARGV[1] = response JSON, ARGV[2] = TTL seconds
const IDEM_STORE_LUA = `
redis.call("SET", KEYS[1], ARGV[1], "EX", ARGV[2])
return 1
`;

export type QuotaCheckResult =
  | { type: 'ok'; remaining: number }
  | { type: 'quota_exhausted' }
  | { type: 'session_expired' }
  | { type: 'idem'; cachedResponse: string };

@Injectable()
export class RedisService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(RedisService.name);
  public readonly client: Redis;

  constructor(private readonly configService: ConfigService) {
    const redisUrl = this.configService.get<string>('REDIS_URL', 'redis://localhost:6379');
    this.client = new Redis(redisUrl, {
      enableReadyCheck: true,
      maxRetriesPerRequest: 3,
      retryStrategy: (times) => Math.min(times * 100, 3000),
    });
  }

  async onModuleInit() {
    await this.client.ping();
    this.logger.log('Redis connected');
  }

  async onModuleDestroy() {
    await this.client.quit();
    this.logger.log('Redis disconnected');
  }

  /**
   * Atomic quota check + decrement for guest sessions.
   * Uses a Lua script to ensure atomicity — no TOCTOU race conditions.
   */
  async checkAndDecrementQuota(
    guestRef: string,
    idempotencyKey: string,
    ttlSeconds: number,
  ): Promise<QuotaCheckResult> {
    const sessionKey = `guest:session:${guestRef}`;
    const quotaKey = `guest:quota:quicktip:${guestRef}`;
    const idemKey = `idem:guest_quicktip:${idempotencyKey}`;

    const result = await this.client.eval(
      QUOTA_CHECK_LUA,
      3,
      sessionKey,
      quotaKey,
      idemKey,
    ) as string[];

    switch (result[0]) {
      case 'ok':
        return { type: 'ok', remaining: parseInt(result[1], 10) };
      case 'quota_exhausted':
        return { type: 'quota_exhausted' };
      case 'session_expired':
        return { type: 'session_expired' };
      case 'idem':
        return { type: 'idem', cachedResponse: result[1] };
      default:
        return { type: 'session_expired' };
    }
  }

  async storeIdempotencyResult(key: string, response: unknown, ttlSeconds = 60): Promise<void> {
    const idemKey = `idem:${key}`;
    await this.client.setex(idemKey, ttlSeconds, JSON.stringify(response));
  }

  async getIdempotencyResult(key: string): Promise<unknown | null> {
    const idemKey = `idem:${key}`;
    const val = await this.client.get(idemKey);
    return val ? JSON.parse(val) : null;
  }

  async setWithAbsoluteTtl(key: string, value: string, ttlSeconds: number): Promise<void> {
    await this.client.setex(key, ttlSeconds, value);
  }

  async get(key: string): Promise<string | null> {
    return this.client.get(key);
  }

  async del(...keys: string[]): Promise<void> {
    if (keys.length > 0) {
      await this.client.del(...keys);
    }
  }

  async exists(...keys: string[]): Promise<boolean> {
    const count = await this.client.exists(...keys);
    return count > 0;
  }

  async ttl(key: string): Promise<number> {
    return this.client.ttl(key);
  }

  async getKeys(pattern: string): Promise<string[]> {
    return this.client.keys(pattern);
  }

  async lrange(key: string, start: number, stop: number): Promise<string[]> {
    return this.client.lrange(key, start, stop);
  }

  async rpush(key: string, ...values: string[]): Promise<void> {
    await this.client.rpush(key, ...values);
    // Note: TTL is not set here because it should already be set at session creation
  }

  async ping(): Promise<string> {
    return this.client.ping();
  }
}

