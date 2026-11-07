import { Controller, Get, Patch, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiHeader } from '@nestjs/swagger';
import { MeService } from './me.service';
import { UpdateProfileDto } from './me.dto';
import { Public } from '../../common/decorators/public.decorator';
import { CurrentUser, AuthenticatedUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Me')
@Controller('me')
export class MeController {
  constructor(private readonly meService: MeService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get profile and summary (limited for guests, full for registered)' })
  @ApiHeader({ name: 'X-Guest-Ref', required: false })
  @ApiBearerAuth('access-token')
  async getProfile(@CurrentUser() user?: AuthenticatedUser) {
    return this.meService.getProfile(user);
  }

  @Get('history')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Get learning history (tips, videos, assessments, events)' })
  async getHistory(@CurrentUser() user: AuthenticatedUser) {
    return this.meService.getHistory(user.id);
  }

  @Get('progress')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Get authoritative Confy points and level' })
  async getProgress(@CurrentUser() user: AuthenticatedUser) {
    return this.meService.getProgress(user.id);
  }

  @Patch()
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Update profile and notification preferences' })
  async updateProfile(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: UpdateProfileDto,
  ) {
    return this.meService.updateProfile(user.id, dto);
  }
}

