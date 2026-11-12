import { Module } from "@nestjs/common";
import { QuicktipsController } from "./quicktips.controller";
import { QuicktipsService } from "./quicktips.service";
import { GuestModule } from "../guest/guest.module";

@Module({
  imports: [GuestModule],
  controllers: [QuicktipsController],
  providers: [QuicktipsService],
  exports: [QuicktipsService],
})
export class QuicktipsModule {}

