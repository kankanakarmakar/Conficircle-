export const configValidationSchema = {
  validate: (config: Record<string, unknown>) => {
    // Basic defaults and fallbacks for env vars
    return {
      NODE_ENV: config.NODE_ENV || 'development',
      PORT: config.PORT ? Number(config.PORT) : 3000,
      DATABASE_URL: config.DATABASE_URL || 'postgresql://confcircle:change_me_dev_password@localhost:5432/confcircle?schema=public',
      REDIS_URL: config.REDIS_URL || 'redis://localhost:6379',
      JWT_SECRET: config.JWT_SECRET || 'dev-jwt-secret-replace-in-production-min-32-chars',
      JWT_REFRESH_SECRET: config.JWT_REFRESH_SECRET || 'dev-jwt-refresh-secret-replace-in-production',
      JWT_ACCESS_TTL: config.JWT_ACCESS_TTL || '900s',
      JWT_REFRESH_TTL: config.JWT_REFRESH_TTL || '30d',
      CORS_ORIGINS: config.CORS_ORIGINS || 'http://localhost:8080,http://localhost:3000',
      GUEST_TTL_SECONDS: config.GUEST_TTL_SECONDS ? Number(config.GUEST_TTL_SECONDS) : 3600,
      GUEST_QUICKTIP_QUOTA: config.GUEST_QUICKTIP_QUOTA ? Number(config.GUEST_QUICKTIP_QUOTA) : 3,
      GUEST_QUESTION_COUNT: config.GUEST_QUESTION_COUNT ? Number(config.GUEST_QUESTION_COUNT) : 3,
      VIDEO_COMPLETION_THRESHOLD: config.VIDEO_COMPLETION_THRESHOLD ? Number(config.VIDEO_COMPLETION_THRESHOLD) : 0.9,
      VIDEO_URL_SIGN_SECRET: config.VIDEO_URL_SIGN_SECRET || 'default-video-sign-secret',
      DOWNLOAD_URL_SIGN_SECRET: config.DOWNLOAD_URL_SIGN_SECRET || 'default-download-sign-secret',
      EMAIL_PROVIDER: config.EMAIL_PROVIDER || 'stub',
      WHATSAPP_PROVIDER: config.WHATSAPP_PROVIDER || 'stub',
    };
  },
};

