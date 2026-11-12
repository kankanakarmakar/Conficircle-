import { Controller, Get, Post, Body, HttpCode, HttpStatus } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from "@nestjs/swagger";
import { ProgressService } from "./progress.service";
import {
  UserProgressDto,
  RecordVideoProgressDto,
  VideoProgressResponseDto,
  AnalyticsBatchDto,
} from "./dto/progress.dto";

@ApiTags("Progress")
@Controller("v1")
export class ProgressController {
  constructor(private readonly progressService: ProgressService) {}

  @Get("progress")
  @ApiBearerAuth()
  @ApiOperation({ summary: "Get user progress, streaks, badges, Confy points balance, and activity feed" })
  @ApiResponse({ status: 200, description: "Progress summary payload", type: UserProgressDto })
  getProgress(): UserProgressDto {
    return this.progressService.getProgress();
  }

  @Post("progress/video")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Record video playback heartbeat or completion milestone" })
  @ApiResponse({ status: 200, description: "Milestone recorded and points calculated", type: VideoProgressResponseDto })
  recordVideo(@Body() dto: RecordVideoProgressDto): VideoProgressResponseDto {
    return this.progressService.recordVideoProgress(dto);
  }

  @Post("analytics/events")
  @HttpCode(HttpStatus.ACCEPTED)
  @ApiOperation({ summary: "Batch ingest client interaction telemetry for recommendation engine" })
  @ApiResponse({ status: 202, description: "Batch accepted for background processing" })
  ingestAnalytics(@Body() dto: AnalyticsBatchDto): { status: string; count: number } {
    return this.progressService.ingestAnalytics(dto);
  }
}

