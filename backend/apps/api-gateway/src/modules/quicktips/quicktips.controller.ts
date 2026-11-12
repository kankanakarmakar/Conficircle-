import { Controller, Post, Param, Headers, HttpCode, HttpStatus } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse, ApiHeader, ApiParam } from "@nestjs/swagger";
import { QuicktipsService } from "./quicktips.service";
import { QuickTipOpenResponseDto } from "./dto/quicktip.dto";

@ApiTags("QuickTips")
@Controller("v1/quicktips")
export class QuicktipsController {
  constructor(private readonly quicktipsService: QuicktipsService) {}

  @Post(":id/open")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Open and unlock a micro-coaching quick tip (applies guest quota deduction with idempotency guard)" })
  @ApiParam({ name: "id", example: "qt-1", description: "Quick tip identifier" })
  @ApiHeader({ name: "X-Guest-Ref", required: false, description: "Guest reference header" })
  @ApiHeader({ name: "Idempotency-Key", required: false, description: "UUID idempotency key to prevent double-deduction" })
  @ApiResponse({ status: 200, description: "Tip unlocked successfully", type: QuickTipOpenResponseDto })
  openTip(
    @Param("id") id: string,
    @Headers("x-guest-ref") guestRef?: string,
    @Headers("idempotency-key") idempotencyKey?: string,
  ): QuickTipOpenResponseDto {
    return this.quicktipsService.openTip(id, guestRef, idempotencyKey);
  }
}

