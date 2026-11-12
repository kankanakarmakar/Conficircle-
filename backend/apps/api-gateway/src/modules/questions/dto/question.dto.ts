import { ApiProperty } from "@nestjs/swagger";

export class PermittedActionDto {
  @ApiProperty({ example: "quicktip", enum: ["quicktip", "video", "assessment"] })
  actionType!: string;

  @ApiProperty({ example: true })
  enabled!: boolean;

  @ApiProperty({ example: 3, required: false })
  quotaRemaining?: number;

  @ApiProperty({ example: "ACCOUNT_REQUIRED", required: false })
  reason?: string;
}

export class QuickTipItemDto {
  @ApiProperty({ example: "qt-1" })
  id!: string;

  @ApiProperty({ example: "Write down your main point on paper before speaking." })
  content!: string;

  @ApiProperty({ example: 1 })
  order!: number;
}

export class VideoSolutionItemDto {
  @ApiProperty({ example: "vid-1" })
  id!: string;

  @ApiProperty({ example: "Mastering Meeting Participation in High-Stakes Settings" })
  title!: string;

  @ApiProperty({ example: 240, description: "Duration in seconds" })
  durationSec!: number;

  @ApiProperty({ example: true })
  requiresRegistration!: boolean;

  @ApiProperty({ example: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", required: false })
  videoUrl?: string;
}

export class AssessmentItemDto {
  @ApiProperty({ example: "ass-1" })
  id!: string;

  @ApiProperty({ example: "Communication & Decisiveness Assessment" })
  title!: string;

  @ApiProperty({ example: 5 })
  questionCount!: number;

  @ApiProperty({ example: true })
  requiresRegistration!: boolean;
}

export class QuestionDetailDto {
  @ApiProperty({ example: "l4-001" })
  questionId!: string;

  @ApiProperty({ example: "How do I stop overthinking in group meetings and actually speak up?" })
  prompt!: string;

  @ApiProperty({ example: "Quick tactics to contribute before hesitation takes over" })
  shortDescription!: string;

  @ApiProperty({ type: () => [PermittedActionDto] })
  permittedActions!: PermittedActionDto[];

  @ApiProperty({ type: () => [QuickTipItemDto] })
  quickTips!: QuickTipItemDto[];

  @ApiProperty({ type: () => [VideoSolutionItemDto] })
  videoSolutions!: VideoSolutionItemDto[];

  @ApiProperty({ type: () => [AssessmentItemDto] })
  assessments!: AssessmentItemDto[];
}

