import {
  Controller,
  Post,
  Get,
  Param,
  Body,
  Headers,
  UseGuards,
  HttpCode,
  HttpStatus,
  BadRequestException,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiHeader } from '@nestjs/swagger';
import { GuestService } from './guest.service';
import { CreateGuestSessionDto, GuestSessionResponseDto } from './guest.dto';
import { Public } from '../../common/decorators/public.decorator';
import { ErrorCode } from '../../common/dto/error.dto';

@ApiTags('Guest')
@Controller('guest')
export class GuestController {
  constructor(private readonly guestService: GuestService) {}

  @Public()
  @Post('session')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Obtain an anonymous guest session with absolute TTL' })
  @ApiResponse({ status: 201, type: GuestSessionResponseDto })
  async createSession(@Body() dto: CreateGuestSessionDto): Promise<GuestSessionResponseDto> {
    return this.guestService.createSession(dto);
  }

  @Public()
  @Get('questions')
  @ApiHeader({ name: 'X-Guest-Ref', description: 'Opaque guest reference token' })
  @ApiOperation({ summary: 'Get 2-3 randomized Level 4 guest questions (cached per session)' })
  async getQuestions(@Headers('x-guest-ref') guestRef: string) {
    if (!guestRef) {
      throw new BadRequestException({
        code: ErrorCode.VALIDATION_FAILED,
        message: 'Header X-Guest-Ref is required',
      });
    }
    return this.guestService.getQuestions(guestRef);
  }
}

