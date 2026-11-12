import { ApiProperty } from "@nestjs/swagger";
import { IsArray, IsBoolean, IsNotEmpty, IsNumber, IsOptional, IsString } from "class-validator";

export class BadgeDto {
  @ApiProperty({ example: "badge-first-step" })
  id!: string;

  @ApiProperty({ example: "First Step Taken" })
  name!: string;

  @ApiProperty({ example: "Unlocked your first micro-coaching quick tip." })
  description!: string;

  @ApiProperty({ example: "assets/icons/badge_first.png" })
  iconUrl!: string;

  @ApiProperty({ example: "2026-11-12T00:00:00.000Z" })
  unlockedAt!: string;
}

export class ActivityItemDto {
  @ApiProperty({ example: "act-01" })
  id!: string;

  @ApiProperty({ example: "Unlocked Quick Tip: Meeting Preparation" })
  title!: string;

  @ApiProperty({ example: "+10 Confy Points" })
  rewardText!: string;

  @ApiProperty({ example: "2026-11-12T00:00:00.000Z" })
  timestamp!: string;
}

export class UserProgressDto {
  @ApiProperty({ example: 180, description: "Total Confy points balance" })
  confyPoints!: number;

  @ApiProperty({ example: 4, description: "Consecutive daily streak" })
  streakDays!: number;

  @ApiProperty({ example: 2, description: "Count of finished topics" })
  completedTopicsCount!: number;

  @ApiProperty({ type: () => [BadgeDto] })
  badges!: BadgeDto[];

  @ApiProperty({ type: () => [ActivityItemDto] })
  recentActivity!: ActivityItemDto[];
}

export class RecordVideoProgressDto {
  @ApiProperty({ example: "vid-1" })
  @IsString()
  @IsNotEmpty()
  videoId!: string;

  @ApiProperty({ example: "top-001" })
  @IsString()
  @IsNotEmpty()
  topicId!: string;

  @ApiProperty({ example: 120, description: "Current playback position in seconds" })
  @IsNumber()
  positionSeconds!: number;

  @ApiProperty({ example: 240, description: "Total video duration in seconds" })
  @IsNumber()
  durationSeconds!: number;

  @ApiProperty({ example: false, required: false })
  @IsBoolean()
  @IsOptional()
  completed?: boolean;
}

export class VideoProgressResponseDto {
  @ApiProperty({ example: true })
  recorded!: boolean;

  @ApiProperty({ example: 15, description: "Points awarded for this milestone" })
  pointsAwarded!: number;

  @ApiProperty({ example: 50.0, description: "Percentage of video completed" })
  percentComplete!: number;
}

export class AnalyticsEventDto {
  @ApiProperty({ example: "action_click" })
  @IsString()
  @IsNotEmpty()
  event!: string;

  @ApiProperty({ example: "l4-001", required: false })
  @IsString()
  @IsOptional()
  entity_id?: string;

  @ApiProperty({ example: "action", required: false })
  @IsString()
  @IsOptional()
  entity_type?: string;

  @ApiProperty({ example: { category: "Communication" }, required: false })
  @IsOptional()
  properties?: Record<string, any>;

  @ApiProperty({ example: "2026-11-12T00:00:00.000Z" })
  @IsString()
  @IsNotEmpty()
  timestamp!: string;
}

export class AnalyticsBatchDto {
  @ApiProperty({ type: () => [AnalyticsEventDto] })
  @IsArray()
  events!: AnalyticsEventDto[];
}

