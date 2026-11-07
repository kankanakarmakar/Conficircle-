import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiHeader } from '@nestjs/swagger';
import { CircleService } from './circle.service';
import { CreatePostDto } from './circle.dto';
import { Public } from '../../common/decorators/public.decorator';
import { CurrentUser, AuthenticatedUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Circle')
@Controller('circle')
export class CircleController {
  constructor(private readonly circleService: CircleService) {}

  @Public()
  @Get('groups')
  @ApiOperation({ summary: 'List public/joined circle groups' })
  async getGroups(@CurrentUser() user?: AuthenticatedUser) {
    return this.circleService.getGroups(user);
  }

  @Public()
  @Get('feed')
  @ApiOperation({ summary: 'Get community feed posts based on visibility permissions' })
  async getFeed(@CurrentUser() user?: AuthenticatedUser) {
    return this.circleService.getFeed(user);
  }

  @Post('groups/:id/join')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Join a circle group (registered user)' })
  async joinGroup(
    @Param('id') groupId: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return this.circleService.joinGroup(groupId, user.id);
  }

  @Post('groups/:id/leave')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Leave a circle group' })
  async leaveGroup(
    @Param('id') groupId: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return this.circleService.leaveGroup(groupId, user.id);
  }

  @Post('posts')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Create a post in a joined group' })
  async createPost(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: CreatePostDto,
  ) {
    return this.circleService.createPost(user.id, dto);
  }
}

