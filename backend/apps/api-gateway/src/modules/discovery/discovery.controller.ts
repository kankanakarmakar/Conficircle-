import { Controller, Get, Post, Body, Query, Headers, HttpCode, HttpStatus } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse, ApiHeader, ApiQuery } from "@nestjs/swagger";
import { DiscoveryService } from "./discovery.service";
import { DiscoveryBatchDto, ShuffleBatchDto, DiscoveryEventDto } from "./dto/discovery.dto";

@ApiTags("Discovery")
@Controller("v1/discovery")
export class DiscoveryController {
  constructor(private readonly discoveryService: DiscoveryService) {}

  @Get("guest")
  @ApiOperation({ summary: "Get curated Level 4 question discovery batch for anonymous guests" })
  @ApiQuery({ name: "limit", required: false, example: 8, description: "Batch item count (7-8)" })
  @ApiQuery({ name: "previous_batch_id", required: false, description: "Batch ID to avoid duplicate selections" })
  @ApiHeader({ name: "X-Guest-Ref", required: false, description: "Guest identity reference" })
  @ApiResponse({ status: 200, description: "Discovery batch returned", type: DiscoveryBatchDto })
  getGuestBatch(
    @Query("limit") limit?: number,
    @Query("previous_batch_id") previousBatchId?: string,
  ): DiscoveryBatchDto {
    return this.discoveryService.getGuestBatch(limit ? Number(limit) : 8, previousBatchId);
  }

  @Post("guest/shuffle")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Shuffle questions for a guest to discover new Level 4 topics" })
  @ApiHeader({ name: "X-Guest-Ref", required: false, description: "Guest identity reference" })
  @ApiResponse({ status: 200, description: "New shuffled discovery batch", type: DiscoveryBatchDto })
  shuffleGuestBatch(@Body() dto: ShuffleBatchDto): DiscoveryBatchDto {
    return this.discoveryService.shuffleGuestBatch(dto);
  }

  @Get("registered")
  @ApiOperation({ summary: "Get personalized discovery batch for logged-in registered members" })
  @ApiQuery({ name: "limit", required: false, example: 6, description: "Batch item count (5-6)" })
  @ApiQuery({ name: "context", required: false, description: "Contextual preference filter" })
  @ApiResponse({ status: 200, description: "Personalized discovery batch returned", type: DiscoveryBatchDto })
  getRegisteredBatch(
    @Query("limit") limit?: number,
    @Query("context") context?: string,
  ): DiscoveryBatchDto {
    return this.discoveryService.getRegisteredBatch(limit ? Number(limit) : 6, context);
  }

  @Post("registered/shuffle")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Shuffle personalized questions for a registered member" })
  @ApiResponse({ status: 200, description: "Fresh discovery batch", type: DiscoveryBatchDto })
  shuffleRegisteredBatch(@Body() dto: ShuffleBatchDto): DiscoveryBatchDto {
    return this.discoveryService.shuffleRegisteredBatch(dto);
  }

  @Post("events")
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: "Record discovery telemetry events (card impressions, prompt clicks, expansions)" })
  @ApiHeader({ name: "X-Guest-Ref", required: false, description: "Guest reference" })
  @ApiResponse({ status: 201, description: "Event recorded" })
  recordEvent(@Body() dto: DiscoveryEventDto): { status: string; receivedAt: string } {
    return this.discoveryService.recordEvent(dto);
  }
}

