import { Controller, Get, Put, Param, Body, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiHeader } from '@nestjs/swagger';
import { VideosService } from './videos.service';
import { VideoProgressDto } from './videos.dto';
import { CurrentUser, AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { IdempotencyKey } from '../../common/decorators/idempotency-key.decorator';

@ApiTags('Videos')
@Controller('videos')
export class VideosController {
  constructor(private readonly videosService: VideosService) {}

  @Get(':id')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Get video solution metadata (registered only)' })
  async getVideo(@Param('id') id: string) {
    return this.videosService.getVideo(id);
  }

  @Get(':id/playback-url')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Generate a short-lived HMAC signed video streaming URL' })
  async getPlaybackUrl(
    @Param('id') id: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return this.videosService.getPlaybackUrl(id, user.id);
  }

  @Put(':id/progress')
  @ApiBearerAuth('access-token')
  @ApiHeader({ name: 'Idempotency-Key', required: true })
  @ApiOperation({ summary: 'Send periodic progress checkpoint and auto-complete' })
  async updateProgress(
    @Param('id') id: string,
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: VideoProgressDto,
  ) {
    return this.videosService.updateProgress(id, user.id, dto);
  }
}

