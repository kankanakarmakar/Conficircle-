import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiHeader } from '@nestjs/swagger';
import { HomeService } from './home.service';
import { Public } from '../../common/decorators/public.decorator';
import { CurrentUser, AuthenticatedUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Home')
@Controller('home')
export class HomeController {
  constructor(private readonly homeService: HomeService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get role-appropriate Home dashboard (guest vs registered)' })
  @ApiHeader({ name: 'X-Guest-Ref', required: false, description: 'Optional guest reference' })
  @ApiBearerAuth('access-token')
  async getHome(@CurrentUser() user?: AuthenticatedUser) {
    return this.homeService.getHomeDashboard(user);
  }
}

