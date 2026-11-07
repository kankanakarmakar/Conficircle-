import { Module } from '@nestjs/common';
import { ConfigPublicController } from './config-public.controller';
import { ConfigPublicService } from './config-public.service';

@Module({
  controllers: [ConfigPublicController],
  providers: [ConfigPublicService],
  exports: [ConfigPublicService],
})
export class ConfigPublicModule {}

