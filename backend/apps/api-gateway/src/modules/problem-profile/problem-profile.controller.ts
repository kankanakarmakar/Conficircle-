import { Controller, Get, Post, Patch, Body, Param, HttpCode, HttpStatus } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse, ApiParam } from "@nestjs/swagger";
import { ProblemProfileService } from "./problem-profile.service";
import {
  ConcernPromptDto,
  SaveProblemProfileDto,
  UpdateProblemProfileDto,
  UserConcernProfileDto,
  ProblemProfileSavedResponseDto,
} from "./dto/problem-profile.dto";

@ApiTags("ProblemProfile")
@Controller("v1/problem-profile")
export class ProblemProfileController {
  constructor(private readonly problemProfileService: ProblemProfileService) {}

  @Get("concerns")
  @ApiOperation({ summary: "Fetch curated list of confidence & interpersonal concern prompts" })
  @ApiResponse({ status: 200, description: "Curated concerns list", type: [ConcernPromptDto] })
  getCuratedConcerns(): ConcernPromptDto[] {
    return this.problemProfileService.getCuratedConcerns();
  }

  @Get()
  @ApiOperation({ summary: "Get the current user's active concern problem profile" })
  @ApiResponse({ status: 200, description: "Active problem profile items", type: [UserConcernProfileDto] })
  getUserProfile(): UserConcernProfileDto[] {
    return this.problemProfileService.getUserProfile();
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: "Save or update user concern selections and personalization consent" })
  @ApiResponse({ status: 201, description: "Profile preferences saved", type: ProblemProfileSavedResponseDto })
  saveProfile(@Body() dto: SaveProblemProfileDto): ProblemProfileSavedResponseDto {
    return this.problemProfileService.saveProfile(dto);
  }

  @Patch(":id")
  @ApiOperation({ summary: "Update status or priority of a specific problem profile concern" })
  @ApiParam({ name: "id", example: "upp-concern-01", description: "Profile concern identifier" })
  @ApiResponse({ status: 200, description: "Updated profile concern item", type: UserConcernProfileDto })
  updateProfile(
    @Param("id") id: string,
    @Body() dto: UpdateProblemProfileDto,
  ): UserConcernProfileDto {
    return this.problemProfileService.updateProfile(id, dto);
  }
}

