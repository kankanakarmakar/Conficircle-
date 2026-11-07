import { Module, MiddlewareConsumer, NestModule } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { APP_GUARD, APP_INTERCEPTOR, APP_FILTER } from '@nestjs/core';
import { BullModule } from '@nestjs/bull';
import { PrismaModule } from './prisma/prisma.module';
import { RedisModule } from './redis/redis.module';
import { AuthModule } from './modules/auth/auth.module';
import { GuestModule } from './modules/guest/guest.module';
import { ConfigPublicModule } from './modules/config-public/config-public.module';
import { HomeModule } from './modules/home/home.module';
import { TopicsModule } from './modules/topics/topics.module';
import { QuickTipsModule } from './modules/quicktips/quicktips.module';
import { VideosModule } from './modules/videos/videos.module';
import { AssessmentsModule } from './modules/assessments/assessments.module';
import { ResourcesModule } from './modules/resources/resources.module';
import { CircleModule } from './modules/circle/circle.module';
import { MeModule } from './modules/me/me.module';
import { CoursesModule } from './modules/courses/courses.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { HealthModule } from './modules/health/health.module';
import { JwtAuthGuard } from './common/guards/jwt-auth.guard';
import { RolesGuard } from './common/guards/roles.guard';
import { EntitlementGuard } from './common/guards/entitlement.guard';
import { IdempotencyInterceptor } from './common/interceptors/idempotency.interceptor';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';
import { RequestIdMiddleware } from './common/middleware/request-id.middleware';
import { configValidationSchema } from './config/config.schema';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env', '../../.env'],
      validationSchema: configValidationSchema,
    }),
    BullModule.forRootAsync({
      useFactory: () => ({
        redis: process.env.REDIS_URL || 'redis://localhost:6379',
      }),
    }),
    PrismaModule,
    RedisModule,
    AuthModule,
    GuestModule,
    ConfigPublicModule,
    HomeModule,
    TopicsModule,
    QuickTipsModule,
    VideosModule,
    AssessmentsModule,
    ResourcesModule,
    CircleModule,
    MeModule,
    CoursesModule,
    NotificationsModule,
    HealthModule,
  ],
  providers: [
    // Global guards (order matters)
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    { provide: APP_GUARD, useClass: RolesGuard },
    { provide: APP_GUARD, useClass: EntitlementGuard },
    // Global interceptors
    { provide: APP_INTERCEPTOR, useClass: IdempotencyInterceptor },
    // Global filters
    { provide: APP_FILTER, useClass: HttpExceptionFilter },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(RequestIdMiddleware).forRoutes('*');
  }
}

