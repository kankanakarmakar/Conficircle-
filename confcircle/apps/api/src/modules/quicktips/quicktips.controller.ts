import { Controller, Post, Get, Param, Headers } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiHeader } from '@nestjs/swagger';
import { QuickTipsService } from './quicktips.service';
import { Public } from '../../common/decorators/public.decorator';
import { CurrentUser, AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { IdempotencyKey } from '../../common/decorators/idempotency-key.decorator';

@ApiTags('QuickTips')
@Controller('quicktips')
export class QuickTipsController {
  constructor(private readonly quicktipsService: QuickTipsService) {}

  @Public()
  @Post(':id/open')
  @ApiOperation({ summary: 'Open a Quick Tip (consumes guest quota atomically or unlocks for registered user)' })
  @ApiHeader({ name: 'X-Guest-Ref', required: false })
  @ApiHeader({ name: 'Idempotency-Key', required: true })
  @ApiBearerAuth('access-token')
  async openQuickTip(
    @Param('id') id: string,
    @CurrentUser() user?: AuthenticatedUser,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.quicktipsService.openQuickTip(id, user, idempotencyKey);
  }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get Quick Tip by ID' })
  async getQuickTip(@Param('id') id: string) {
    return this.quicktipsService.getQuickTip(id);
  }
}

