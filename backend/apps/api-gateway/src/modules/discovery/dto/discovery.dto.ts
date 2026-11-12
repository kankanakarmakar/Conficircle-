import { ApiProperty } from "@nestjs/swagger";
import { IsArray, IsNotEmpty, IsOptional, IsString } from "class-validator";

export class QuestionItemDto {
  @ApiProperty({ example: "l4-001", description: "Unique question ID" })
  questionId!: string;

  @ApiProperty({ example: "How do I stop overthinking in group meetings and actually speak up?", description: "Question prompt" })
  prompt!: string;

  @ApiProperty({ example: "Quick tactics to contribute before hesitation takes over", description: "Summary line" })
  shortDescription!: string;

  @ApiProperty({ example: "assets/images/l4_meeting.png", required: false, description: "Illustration asset path" })
  displayAsset?: string;

  @ApiProperty({ example: "Based on your recent interest", required: false, description: "Personalization rationale label" })
  safeReasonLabel?: string;
}

export class DiscoveryBatchDto {
  @ApiProperty({ example: "batch_guest_982314", description: "Unique batch identifier" })
  batchId!: string;

  @ApiProperty({ example: "guest", enum: ["guest", "registered"], description: "Target audience tier" })
  audience!: "guest" | "registered";

  @ApiProperty({ type: () => [QuestionItemDto], description: "Curated questions in this discovery batch" })
  items!: QuestionItemDto[];

  @ApiProperty({ example: 1762950000000, required: false, description: "Batch expiration epoch milliseconds" })
  expiresAt?: number;
}

export class ShuffleBatchDto {
  @ApiProperty({ example: "batch_guest_982314", description: "Previous batch ID being refreshed" })
  @IsString()
  @IsNotEmpty()
  previousBatchId!: string;

  @ApiProperty({ example: ["l4-001", "l4-002"], required: false, type: [String], description: "Question IDs to exclude from the next shuffle" })
  @IsArray()
  @IsOptional()
  excludedIds?: string[];
}

export class DiscoveryEventDto {
  @ApiProperty({ example: "card_impression", description: "Interaction event type (e.g. card_impression, prompt_click, tip_expanded)" })
  @IsString()
  @IsNotEmpty()
  eventType!: string;

  @ApiProperty({ example: "l4-001", description: "Target question ID" })
  @IsString()
  @IsNotEmpty()
  questionId!: string;

  @ApiProperty({ example: { dwellTimeMs: 4200, screen: "discovery_feed" }, required: false, description: "Telemetry metadata" })
  @IsOptional()
  metadata?: Record<string, any>;
}

