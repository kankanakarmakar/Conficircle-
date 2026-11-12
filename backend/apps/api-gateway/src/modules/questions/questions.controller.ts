import { Controller, Get, Param, Headers } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse, ApiHeader, ApiParam } from "@nestjs/swagger";
import { QuestionsService } from "./questions.service";
import { QuestionDetailDto } from "./dto/question.dto";

@ApiTags("Questions")
@Controller("v1/questions")
export class QuestionsController {
  constructor(private readonly questionsService: QuestionsService) {}

  @Get(":id")
  @ApiOperation({ summary: "Retrieve comprehensive question details including quick tips, video teasers, and assessments" })
  @ApiParam({ name: "id", example: "l4-001", description: "Question ID" })
  @ApiHeader({ name: "X-Guest-Ref", required: false, description: "Guest identity reference for quota evaluation" })
  @ApiResponse({ status: 200, description: "Detailed question payload", type: QuestionDetailDto })
  getQuestion(
    @Param("id") id: string,
    @Headers("x-guest-ref") guestRef?: string,
  ): QuestionDetailDto {
    return this.questionsService.getQuestionDetail(id, guestRef);
  }

  @Get()
  @ApiOperation({ summary: "List all indexed questions" })
  @ApiResponse({ status: 200, description: "List of question details", type: [QuestionDetailDto] })
  getAll(): QuestionDetailDto[] {
    return this.questionsService.getAllQuestions();
  }
}

