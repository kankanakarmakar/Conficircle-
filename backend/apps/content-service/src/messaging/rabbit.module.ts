/**
 * Provides the shared RabbitMQService instance as a global dynamic
 * module so any module in the app can inject RMS rabbit access.
 */
import { DynamicModule, Module } from "@nestjs/common";

export const RABBIT_TOKEN = Symbol("RABBIT_MQ_SERVICE");

@Module({})
export class RabbitModule {
  static forRoot(service: unknown): DynamicModule {
    return {
      global: true,
      module: RabbitModule,
      providers: [{ provide: RABBIT_TOKEN, useValue: service }],
      exports: [RABBIT_TOKEN],
    };
  }
}
