import {
  Controller,
  Get,
  Post,
  Patch,
  Param,
  Query,
  Body,
  Headers,
  HttpCode,
  HttpStatus,
  BadRequestException,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiHeader, ApiBearerAuth } from '@nestjs/swagger';
import { DiscoveryService } from './discovery.service';
import { Public } from '../../common/decorators/public.decorator';
import { CurrentUser, AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { ErrorCode } from '../../common/dto/error.dto';
import {
  GuestDiscoveryBatchQueryDto,
  GuestShuffleDto,
  RegisteredDiscoveryBatchQueryDto,
  RegisteredShuffleDto,
  SaveProblemProfileDto,
  UpdateProblemProfileDto,
  RecordDiscoveryEventDto,
  DiscoveryBatchResponseDto,
  QuestionDetailResponseDto,
  ConcernPromptItemDto,
} from './discovery.dto';

@ApiTags('Discovery & Questions')
@Controller()
export class DiscoveryController {
  constructor(private readonly discoveryService: DiscoveryService) {}

  // ─────────────────────────────────────────────────────────────
  // 1. Guest Discovery Batch (7–8 Level 4 Questions)
  // ─────────────────────────────────────────────────────────────
  @Public()
  @Get('discovery/guest')
  @ApiOperation({ summary: 'Get fresh batch of 7-8 Level 4 question prompts for guest session' })
  @ApiHeader({ name: 'X-Guest-Ref', description: 'Opaque guest reference token', required: true })
  @ApiResponse({ status: 200, type: DiscoveryBatchResponseDto })
  async getGuestBatch(
    @Headers('x-guest-ref') guestRefHeader?: string,
    @Query('guest_ref') guestRefQuery?: string,
    @Query() query?: GuestDiscoveryBatchQueryDto,
  ): Promise<DiscoveryBatchResponseDto> {
    const guestRef = guestRefHeader || guestRefQuery;
    if (!guestRef) {
      throw new BadRequestException({
        code: ErrorCode.VALIDATION_FAILED,
        message: 'Header X-Guest-Ref is required for guest discovery',
      });
    }

    return this.discoveryService.getGuestBatch(
      guestRef,
      query?.limit,
      query?.previous_batch_id,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Guest Shuffle
  // ─────────────────────────────────────────────────────────────
  @Public()
  @Post('discovery/guest/shuffle')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Shuffle and retrieve a fresh batch of 7-8 Level 4 question prompts for guest' })
  @ApiHeader({ name: 'X-Guest-Ref', description: 'Opaque guest reference token', required: true })
  @ApiResponse({ status: 200, type: DiscoveryBatchResponseDto })
  async shuffleGuestBatch(
    @Headers('x-guest-ref') guestRefHeader: string | undefined,
    @Body() dto: GuestShuffleDto,
  ): Promise<DiscoveryBatchResponseDto> {
    const guestRef = guestRefHeader;
    if (!guestRef) {
      throw new BadRequestException({
        code: ErrorCode.VALIDATION_FAILED,
        message: 'Header X-Guest-Ref is required for guest shuffle',
      });
    }

    return this.discoveryService.shuffleGuestBatch(guestRef, dto);
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Registered Discovery Batch (5–6 Level 4 Questions)
  // ─────────────────────────────────────────────────────────────
  @Get('discovery/registered')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Get personalised batch of 5-6 Level 4 question prompts for registered user' })
  @ApiResponse({ status: 200, type: DiscoveryBatchResponseDto })
  async getRegisteredBatch(
    @CurrentUser() user: AuthenticatedUser,
    @Query() query?: RegisteredDiscoveryBatchQueryDto,
  ): Promise<DiscoveryBatchResponseDto> {
    if (!user || user.isGuest) {
      throw new BadRequestException({
        code: ErrorCode.UNAUTHORIZED,
        message: 'Authentication required for registered discovery feed',
      });
    }

    return this.discoveryService.getRegisteredBatch(
      user.id,
      query?.limit,
      query?.context,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Registered Shuffle
  // ─────────────────────────────────────────────────────────────
  @Post('discovery/registered/shuffle')
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Shuffle and retrieve a fresh batch of 5-6 Level 4 question prompts for registered user' })
  @ApiResponse({ status: 200, type: DiscoveryBatchResponseDto })
  async shuffleRegisteredBatch(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: RegisteredShuffleDto,
  ): Promise<DiscoveryBatchResponseDto> {
    if (!user || user.isGuest) {
      throw new BadRequestException({
        code: ErrorCode.UNAUTHORIZED,
        message: 'Authentication required for registered shuffle',
      });
    }

    return this.discoveryService.shuffleRegisteredBatch(user.id, dto);
  }

  // ─────────────────────────────────────────────────────────────
  // 5. Question Detail & Content Access
  // ─────────────────────────────────────────────────────────────
  @Public()
  @Get('questions/:id')
  @ApiOperation({ summary: 'Get question-led detail screen with permitted content actions' })
  @ApiHeader({ name: 'X-Guest-Ref', required: false, description: 'Optional guest reference' })
  @ApiBearerAuth('access-token')
  @ApiResponse({ status: 200, type: QuestionDetailResponseDto })
  async getQuestionDetail(
    @Param('id') questionId: string,
    @CurrentUser() user?: AuthenticatedUser,
    @Headers('x-guest-ref') guestRef?: string,
  ): Promise<QuestionDetailResponseDto> {
    const effectiveUser: AuthenticatedUser | undefined = user || (guestRef ? {
      id: '',
      isGuest: true,
      guestRef,
      role: 'guest' as any,
    } : undefined);

    return this.discoveryService.getQuestionDetail(questionId, effectiveUser);
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Problem Profile & Personalisation
  // ─────────────────────────────────────────────────────────────
  @Public()
  @Get('problem-profile/concerns')
  @ApiOperation({ summary: 'Get curated list of plain-language concern statements' })
  @ApiResponse({ status: 200, type: [ConcernPromptItemDto] })
  async getCuratedConcerns(): Promise<ConcernPromptItemDto[]> {
    return this.discoveryService.getCuratedConcerns();
  }

  @Post('problem-profile')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Save selected concern prompts for personalised discovery' })
  async saveProblemProfile(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: SaveProblemProfileDto,
  ) {
    if (!user || user.isGuest) {
      throw new BadRequestException({
        code: ErrorCode.ACCOUNT_REQUIRED,
        message: 'Please sign in or register to persist your problem profile.',
      });
    }

    return this.discoveryService.saveProblemProfile(user.id, dto);
  }

  @Patch('problem-profile/:id')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Edit, pause, or remove a saved concern' })
  async updateProblemProfile(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id') id: string,
    @Body() dto: UpdateProblemProfileDto,
  ) {
    if (!user || user.isGuest) {
      throw new BadRequestException({
        code: ErrorCode.ACCOUNT_REQUIRED,
        message: 'Authentication required to update profile concerns',
      });
    }

    return this.discoveryService.updateProblemProfile(user.id, id, dto);
  }

  @Get('problem-profile')
  @ApiBearerAuth('access-token')
  @ApiOperation({ summary: 'Get current user saved problem profile concerns' })
  async getUserProblemProfile(@CurrentUser() user: AuthenticatedUser) {
    if (!user || user.isGuest) {
      throw new BadRequestException({
        code: ErrorCode.ACCOUNT_REQUIRED,
        message: 'Authentication required to view profile concerns',
      });
    }

    return this.discoveryService.getUserProblemProfile(user.id);
  }

  @Public()
  @Get('recommendations/questions')
  @ApiOperation({ summary: 'Get personalised Level 4 question prompts with safe reason labels' })
  @ApiBearerAuth('access-token')
  async getRecommendations(
    @CurrentUser() user?: AuthenticatedUser,
    @Query('limit') limit?: number,
  ) {
    if (user && !user.isGuest) {
      return this.discoveryService.getRegisteredBatch(user.id, limit);
    }
    // Guest fallback
    return this.discoveryService.getGuestBatch(user?.guestRef || 'guest-anon', limit);
  }

  // ─────────────────────────────────────────────────────────────
  // 7. Discovery Analytics Event
  // ─────────────────────────────────────────────────────────────
  @Public()
  @Post('discovery/events')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Record discovery analytics event (impression, selection, content open)' })
  async recordEvent(
    @CurrentUser() user?: AuthenticatedUser,
    @Headers('x-guest-ref') guestRef?: string,
    @Body() dto?: RecordDiscoveryEventDto,
  ) {
    if (!dto) {
      return { success: false };
    }
    const effectiveUser: AuthenticatedUser | undefined = user || (guestRef ? {
      id: '',
      isGuest: true,
      guestRef,
      role: 'guest' as any,
    } : undefined);

    return this.discoveryService.recordEvent(effectiveUser, dto);
  }
}

