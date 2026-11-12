import { Controller, Get, Post, Param, Body, HttpCode, HttpStatus } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse, ApiParam } from "@nestjs/swagger";
import { AssessmentService } from "./assessment.service";
import {
  AssessmentSummaryDto,
  PublicAssessmentDto,
  SubmitAssessmentDto,
  AssessmentResultDto,
} from "./dto/assessment.dto";

@ApiTags("Assessment")
@Controller("v1/assessment")
export class AssessmentController {
  constructor(private readonly assessmentService: AssessmentService) {}

  @Get()
  @ApiOperation({ summary: "List all available confidence & communication assessments" })
  @ApiResponse({ status: 200, description: "List of assessments", type: [AssessmentSummaryDto] })
  listAssessments(): AssessmentSummaryDto[] {
    return this.assessmentService.listAssessments();
  }

  @Get(":id")
  @ApiOperation({ summary: "Fetch public assessment questions and choices (server-side scoring only)" })
  @ApiParam({ name: "id", example: "ass-1" })
  @ApiResponse({ status: 200, description: "Public assessment payload", type: PublicAssessmentDto })
  @ApiResponse({ status: 404, description: "Assessment not found" })
  getAssessment(@Param("id") id: string): PublicAssessmentDto {
    return this.assessmentService.getAssessment(id);
  }

  @Post(":id/submit")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Submit assessment choices and calculate score, level, and badge rewards" })
  @ApiParam({ name: "id", example: "ass-1" })
  @ApiResponse({ status: 200, description: "Evaluated attempt summary", type: AssessmentResultDto })
  submit(
    @Param("id") id: string,
    @Body() dto: SubmitAssessmentDto,
  ): AssessmentResultDto {
    return this.assessmentService.submit(id, dto);
  }
}

