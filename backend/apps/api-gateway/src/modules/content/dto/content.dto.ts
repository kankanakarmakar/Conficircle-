import { ApiProperty } from "@nestjs/swagger";

export class TopicDto {
  @ApiProperty({ example: "top-001" })
  id!: string;

  @ApiProperty({ example: "Speaking Up in Meetings" })
  title!: string;

  @ApiProperty({ example: "Master the psychology and timing of making impactful contributions in meetings." })
  description!: string;

  @ApiProperty({ example: "beginner", enum: ["beginner", "intermediate", "advanced"] })
  difficultyLevel!: string;

  @ApiProperty({ example: true })
  isPublished!: boolean;

  @ApiProperty({ example: 1 })
  orderIndex!: number;

  @ApiProperty({ example: 4 })
  lessonCount!: number;

  @ApiProperty({ example: "assets/images/topics/meeting.png", required: false })
  thumbnailUrl?: string;
}

export class TopicDetailDto extends TopicDto {
  @ApiProperty({ type: [Object] })
  lessons!: Array<{ id: string; title: string; durationSec: number; isCompleted: boolean }>;

  @ApiProperty({ type: [Object] })
  exercises!: Array<{ id: string; title: string; prompt: string }>;
}

export class ResourceDto {
  @ApiProperty({ example: "res-001" })
  id!: string;

  @ApiProperty({ example: "Meeting Speaking Framework & Cheat Sheet" })
  title!: string;

  @ApiProperty({ example: "PDF" })
  type!: string;

  @ApiProperty({ example: "Communication" })
  category!: string;

  @ApiProperty({ example: "https://conficircle.com/downloads/meeting-cheatsheet.pdf" })
  downloadUrl!: string;

  @ApiProperty({ example: 102400, description: "File size in bytes" })
  fileSizeBytes!: number;
}

