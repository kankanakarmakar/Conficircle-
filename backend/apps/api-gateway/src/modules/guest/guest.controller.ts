import { Controller, Post, Get, Headers, HttpCode, HttpStatus } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse, ApiHeader } from "@nestjs/swagger";
import { GuestService } from "./guest.service";
import { GuestSessionDto, QuestionPromptSummaryDto } from "./dto/guest.dto";

@ApiTags("Guest")
@Controller("v1/guest")
export class GuestController {
  constructor(private readonly guestService: GuestService) {}

  @Post("session")
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: "Create or retrieve an anonymous guest session with quota allocation" })
  @ApiHeader({ name: "X-Guest-Ref", required: false, description: "Existing guest reference if stored on device" })
  @ApiResponse({ status: 201, description: "Guest session initialized", type: GuestSessionDto })
  createSession(@Headers("x-guest-ref") guestRef?: string): GuestSessionDto {
    return this.guestService.createOrGetSession(guestRef);
  }

  @Get("questions")
  @ApiOperation({ summary: "Fetch introductory Level 4 discovery questions for guest exploration" })
  @ApiHeader({ name: "X-Guest-Ref", required: false, description: "Guest reference" })
  @ApiResponse({ status: 200, description: "List of guest discovery questions", type: [QuestionPromptSummaryDto] })
  getGuestQuestions(): QuestionPromptSummaryDto[] {
    return this.guestService.getGuestQuestions();
  }
}

