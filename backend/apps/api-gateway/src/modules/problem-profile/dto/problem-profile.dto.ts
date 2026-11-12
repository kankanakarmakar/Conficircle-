import { ApiProperty } from "@nestjs/swagger";
import { IsArray, IsBoolean, IsNotEmpty, IsNumber, IsOptional, IsString } from "class-validator";

export class ConcernPromptDto {
  @ApiProperty({ example: "concern-01", description: "Concern prompt unique ID" })
  id!: string;

  @ApiProperty({ example: "I hesitate to speak up in group discussions", description: "User-facing prompt" })
  promptText!: string;

  @ApiProperty({ example: 1, description: "Display sort order" })
  order!: number;

  @ApiProperty({ example: false, required: false, description: "Whether currently selected by user" })
  isSelected?: boolean;
}

export class SaveProblemProfileDto {
  @ApiProperty({ example: ["concern-01", "concern-02"], type: [String], description: "List of concern IDs chosen by user" })
  @IsArray()
  @IsNotEmpty()
  concernPromptIds!: string[];

  @ApiProperty({ example: 1, required: false, description: "Priority level" })
  @IsNumber()
  @IsOptional()
  priority?: number;

  @ApiProperty({ example: { discovery_personalisation: true }, required: false, description: "Consent settings" })
  @IsOptional()
  consentFlags?: Record<string, boolean>;
}

export class UpdateProblemProfileDto {
  @ApiProperty({ example: "active", enum: ["active", "resolved", "archived"], required: false })
  @IsString()
  @IsOptional()
  status?: string;

  @ApiProperty({ example: 2, required: false })
  @IsNumber()
  @IsOptional()
  priority?: number;
}

export class UserConcernProfileDto {
  @ApiProperty({ example: "upp-concern-01" })
  id!: string;

  @ApiProperty({ example: "concern-01" })
  concernPromptId!: string;

  @ApiProperty({ example: "I hesitate to speak up in group discussions" })
  promptText!: string;

  @ApiProperty({ example: "active" })
  status!: string;

  @ApiProperty({ example: 1 })
  priority!: number;
}

export class ProblemProfileSavedResponseDto {
  @ApiProperty({ example: "Problem profile saved successfully" })
  message!: string;

  @ApiProperty({ example: 2 })
  activeConcernCount!: number;

  @ApiProperty({ type: [Object] })
  concerns!: Array<{ id: string; promptText: string }>;
}

