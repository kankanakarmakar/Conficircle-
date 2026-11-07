import { IsOptional, IsString, IsInt, IsArray, IsBoolean, Min, Max, IsUUID } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class QuestionCardDto {
  @ApiProperty({ description: 'Public Question UUID' })
  questionId: string;

  @ApiProperty({ description: 'Natural-language question prompt' })
  prompt: string;

  @ApiPropertyOptional({ description: 'Optional short helper description' })
  shortDescription?: string;

  @ApiPropertyOptional({ description: 'Display asset URL or icon identifier' })
  displayAsset?: string | null;

  @ApiPropertyOptional({ description: 'Safe user-facing reason label, e.g. Based on what you selected' })
  safeReasonLabel?: string;
}

export class DiscoveryBatchResponseDto {
  @ApiProperty({ description: 'Unique batch ID' })
  batchId: string;

  @ApiProperty({ description: 'Audience type: guest or registered' })
  audience: string;

  @ApiProperty({ type: [QuestionCardDto], description: 'Level 4 Question Prompts only' })
  items: QuestionCardDto[];

  @ApiPropertyOptional({ description: 'Expiration timestamp (ms) for cache/session' })
  expiresAt?: number;
}

export class GuestDiscoveryBatchQueryDto {
  @ApiPropertyOptional({ description: 'Batch size limit (default 8, valid: 7 or 8)' })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(7)
  @Max(8)
  limit?: number = 8;

  @ApiPropertyOptional({ description: 'Previous batch ID to suppress repeats' })
  @IsOptional()
  @IsString()
  previous_batch_id?: string;
}

export class GuestShuffleDto {
  @ApiPropertyOptional({ description: 'Previous batch ID' })
  @IsOptional()
  @IsString()
  previousBatchId?: string;

  @ApiPropertyOptional({ type: [String], description: 'Question IDs currently displayed to exclude' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  excludedIds?: string[];
}

export class RegisteredDiscoveryBatchQueryDto {
  @ApiPropertyOptional({ description: 'Batch size limit (default 6, valid: 5 or 6)' })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(5)
  @Max(6)
  limit?: number = 6;

  @ApiPropertyOptional({ description: 'Request context string' })
  @IsOptional()
  @IsString()
  context?: string;
}

export class RegisteredShuffleDto {
  @ApiPropertyOptional({ description: 'Previous batch ID' })
  @IsOptional()
  @IsString()
  previousBatchId?: string;

  @ApiPropertyOptional({ type: [String], description: 'Question IDs currently displayed to exclude' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  excludedIds?: string[];
}

export class SaveProblemProfileDto {
  @ApiProperty({ type: [String], description: 'Selected concern prompt UUIDs' })
  @IsArray()
  @IsString({ each: true })
  concernPromptIds: string[];

  @ApiPropertyOptional({ description: 'Priority level 1-5' })
  @IsOptional()
  @IsInt()
  priority?: number = 1;

  @ApiPropertyOptional({ description: 'Consent flags map' })
  @IsOptional()
  consentFlags?: Record<string, boolean>;
}

export class UpdateProblemProfileDto {
  @ApiPropertyOptional({ description: 'Status: active, paused, or removed' })
  @IsOptional()
  @IsString()
  status?: 'active' | 'paused' | 'removed';

  @ApiPropertyOptional({ description: 'Priority level 1-5' })
  @IsOptional()
  @IsInt()
  priority?: number;
}

export class RecordDiscoveryEventDto {
  @ApiProperty({ description: 'Event type: impression, shuffle, selection, dismissal, content_open, completion' })
  @IsString()
  eventType: 'impression' | 'shuffle' | 'selection' | 'dismissal' | 'content_open' | 'completion';

  @ApiProperty({ description: 'Question UUID' })
  @IsString()
  questionId: string;

  @ApiPropertyOptional({ description: 'Event metadata' })
  @IsOptional()
  metadata?: Record<string, any>;
}

export class ConcernPromptItemDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ description: 'Plain-language concern statement' })
  promptText: string;

  @ApiProperty()
  order: number;
}

export class QuestionDetailResponseDto {
  @ApiProperty()
  questionId: string;

  @ApiProperty()
  prompt: string;

  @ApiPropertyOptional()
  shortDescription?: string;

  @ApiPropertyOptional()
  displayAsset?: string | null;

  @ApiProperty({ description: 'List of actions with permissions: quicktip, video, assessment' })
  permittedContentActions: {
    actionType: 'quicktip' | 'video' | 'assessment';
    enabled: boolean;
    reason?: string; // 'ACCOUNT_REQUIRED' | 'QUOTA_EXHAUSTED'
    quotaRemaining?: number;
  }[];

  @ApiProperty({ description: 'Quick tips mapped to this question context' })
  quickTips: {
    id: string;
    content: string;
    order: number;
  }[];

  @ApiProperty({ description: 'Video solution metadata' })
  videoSolutions: {
    id: string;
    title: string;
    durationSec: number;
    requiresRegistration: boolean;
  }[];

  @ApiProperty({ description: 'Assessment metadata' })
  assessments: {
    id: string;
    title: string;
    questionCount: number;
    requiresRegistration: boolean;
  }[];
}

