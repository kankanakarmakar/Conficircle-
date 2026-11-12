import {
  Controller,
  Get,
  Post,
  Put,
  Param,
  Body,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiHeader } from '@nestjs/swagger';
import { AssessmentsService } from './assessments.service';
import { SaveAnswerDto } from './assessments.dto';
import { CurrentUser, AuthenticatedUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Assessments')
@Controller()
export class AssessmentsController {
  constructor(private readonly assessmentsService: AssessmentsService) {}

  @Get('assessments/:id')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Get assessment details and questions (correct answers omitted)' })
  async getAssessment(@Param('id') id: string) {
    return this.assessmentsService.getAssessment(id);
  }

  @Post('assessments/:id/attempts')
  @ApiBearerAuth('access-token')
  @ApiHeader({ name: 'Idempotency-Key', required: true })
  @ApiOperation({ summary: 'Start a new assessment attempt with server-side timer' })
  async startAttempt(
    @Param('id') id: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return this.assessmentsService.startAttempt(id, user.id);
  }

  @Put('attempts/:id/answers')
  @ApiBearerAuth('access-token')
  @ApiHeader({ name: 'Idempotency-Key', required: true })
  @ApiOperation({ summary: 'Autosave answer during assessment attempt' })
  async saveAnswer(
    @Param('id') attemptId: string,
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: SaveAnswerDto,
  ) {
    return this.assessmentsService.saveAnswer(attemptId, user.id, dto);
  }

  @Post('attempts/:id/submit')
  @ApiBearerAuth('access-token')
  @ApiHeader({ name: 'Idempotency-Key', required: true })
  @ApiOperation({ summary: 'Submit attempt for server-side scoring' })
  async submitAttempt(
    @Param('id') attemptId: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return this.assessmentsService.submitAttempt(attemptId, user.id);
  }
}

