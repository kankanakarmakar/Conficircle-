import { Module } from "@nestjs/common";
import { ProblemProfileController } from "./problem-profile.controller";
import { ProblemProfileService } from "./problem-profile.service";

@Module({
  controllers: [ProblemProfileController],
  providers: [ProblemProfileService],
  exports: [ProblemProfileService],
})
export class ProblemProfileModule {}

