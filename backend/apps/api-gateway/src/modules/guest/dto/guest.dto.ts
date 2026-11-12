import { ApiProperty } from "@nestjs/swagger";

export class GuestSessionDto {
  @ApiProperty({ example: "guest_98af21d0", description: "Anonymous guest reference identifier" })
  guestRef!: string;

  @ApiProperty({ example: 3, description: "Remaining free quick-tip unlocks" })
  quotaRemaining!: number;

  @ApiProperty({ example: "2026-11-12T00:00:00.000Z", description: "Session creation ISO timestamp" })
  createdAt!: string;
}

export class QuestionPromptSummaryDto {
  @ApiProperty({ example: "l4-001", description: "Question identifier" })
  questionId!: string;

  @ApiProperty({ example: "How do I stop overthinking in group meetings and actually speak up?", description: "Question prompt text" })
  prompt!: string;

  @ApiProperty({ example: "Quick tactics to contribute before hesitation takes over", description: "Short description" })
  shortDescription!: string;

  @ApiProperty({ example: "l4_meeting_confidence.png", required: false, description: "Asset banner or icon key" })
  displayAsset?: string;
}

