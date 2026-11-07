import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { ConfigPublicService } from './config-public.service';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('Config')
@Controller('config')
export class ConfigPublicController {
  constructor(private readonly configService: ConfigPublicService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Load remote app configuration, theme, quotas, and feature flags' })
  async getConfig() {
    return this.configService.getConfig();
  }
}

