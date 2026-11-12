import { ApiProperty } from "@nestjs/swagger";

export class QuickTipOpenResponseDto {
  @ApiProperty({ example: "qt-1", description: "Quick tip identifier" })
  id!: string;

  @ApiProperty({
    example: "Write down your main point on paper before speaking. Having 3 bullet points lowers cognitive anxiety by 40%.",
    description: "Actionable psychology-backed tip content",
  })
  content!: string;

  @ApiProperty({ example: 2, description: "Remaining free quota for the guest session" })
  quotaRemaining!: number;

  @ApiProperty({ example: true, description: "Whether content is currently unlocked" })
  isUnlocked!: boolean;

  @ApiProperty({ example: 1, description: "Display order index" })
  order!: number;
}

