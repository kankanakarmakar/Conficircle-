import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiHeader, ApiBearerAuth } from '@nestjs/swagger';
import { TopicsService } from './topics.service';
import { Public } from '../../common/decorators/public.decorator';
import { CurrentUser, AuthenticatedUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Topics')
@Controller('topics')
export class TopicsController {
  constructor(private readonly topicsService: TopicsService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'List learning topics with level/category filters and progress' })
  @ApiQuery({ name: 'category', required: false })
  @ApiQuery({ name: 'level', required: false })
  async getTopics(
    @Query('category') categoryId?: string,
    @Query('level') levelId?: string,
    @CurrentUser() user?: AuthenticatedUser,
  ) {
    return this.topicsService.getTopics(categoryId, levelId, user);
  }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get topic detail with backend-entitlement driven actions' })
  async getTopicDetail(
    @Param('id') id: string,
    @CurrentUser() user?: AuthenticatedUser,
  ) {
    return this.topicsService.getTopicDetail(id, user);
  }

  @Public()
  @Get(':id/content')
  @ApiOperation({ summary: 'Get available Quick Tips and Video Solutions for topic' })
  async getTopicContent(
    @Param('id') id: string,
    @CurrentUser() user?: AuthenticatedUser,
  ) {
    return this.topicsService.getTopicContent(id, user);
  }
}

