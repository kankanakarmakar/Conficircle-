import { Controller, Get, Post, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiHeader } from '@nestjs/swagger';
import { CoursesService } from './courses.service';
import { CurrentUser, AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('Courses')
@Controller()
export class CoursesController {
  constructor(private readonly coursesService: CoursesService) {}

  @Get('courses/mine')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Get enrolled courses, modules, stages, and progress' })
  async getMyCourses(@CurrentUser() user: AuthenticatedUser) {
    return this.coursesService.getMyCourses(user.id);
  }

  @Public()
  @Get('courses/:id')
  @ApiOperation({ summary: 'Get course curriculum and details' })
  async getCourse(@Param('id') id: string) {
    return this.coursesService.getCourse(id);
  }

  @Post('courses/:id/enrol')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Enrol in a course' })
  async enrol(
    @Param('id') id: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return this.coursesService.enrol(id, user.id);
  }

  @Get('stages/:id')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Get stage requirements and completion criteria' })
  async getStage(@Param('id') id: string) {
    return this.coursesService.getStage(id);
  }

  @Post('stages/:id/progress')
  @ApiBearerAuth('access-token')
  @ApiHeader({ name: 'Idempotency-Key', required: true })
  @ApiOperation({ summary: 'Record completion of a course stage' })
  async recordStageProgress(
    @Param('id') id: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return this.coursesService.recordStageProgress(id, user.id);
  }
}

