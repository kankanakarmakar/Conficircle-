import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiHeader, ApiBearerAuth } from '@nestjs/swagger';
import { ResourcesService } from './resources.service';
import { Public } from '../../common/decorators/public.decorator';
import { CurrentUser, AuthenticatedUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Resources')
@Controller('resources')
export class ResourcesController {
  constructor(private readonly resourcesService: ResourcesService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'List published resources with search and category filters' })
  @ApiQuery({ name: 'q', required: false })
  @ApiQuery({ name: 'category', required: false })
  async getResources(
    @Query('q') q?: string,
    @Query('category') category?: string,
    @CurrentUser() user?: AuthenticatedUser,
  ) {
    return this.resourcesService.getResources(q, category, user);
  }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get resource detail metadata' })
  async getResource(
    @Param('id') id: string,
    @CurrentUser() user?: AuthenticatedUser,
  ) {
    return this.resourcesService.getResource(id, user);
  }

  @Public()
  @Get(':id/download-url')
  @ApiOperation({ summary: 'Get authorized short-lived download URL' })
  async getDownloadUrl(
    @Param('id') id: string,
    @CurrentUser() user?: AuthenticatedUser,
  ) {
    return this.resourcesService.getDownloadUrl(id, user);
  }
}

