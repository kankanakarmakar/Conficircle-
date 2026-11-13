import { Module } from '@nestjs/common';
import { QuickTipsController } from './quicktips.controller';
import { QuickTipsService } from './quicktips.service';
import { GuestModule } from '../guest/guest.module';

@Module({
  imports: [GuestModule],
  controllers: [QuickTipsController],
  providers: [QuickTipsService],
  exports: [QuickTipsService],
})
export class QuickTipsModule {}

