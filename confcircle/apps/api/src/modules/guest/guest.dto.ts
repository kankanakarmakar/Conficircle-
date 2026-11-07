import { IsOptional, IsString } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateGuestSessionDto {
  @ApiPropertyOptional({ description: 'Client-generated temporary device or install identifier' })
  @IsOptional()
  @IsString()
  deviceId?: string;
}

export class GuestSessionResponseDto {
  @ApiProperty({ description: 'Opaque guest reference token' })
  guestRef: string;

  @ApiProperty({ description: 'Unix timestamp in ms when session expires' })
  expiresAt: number;

  @ApiProperty({ description: 'Total quick tip quota granted for session' })
  quotaRemaining: number;
}

export class GuestQuestionDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  content: string;

  @ApiProperty({ type: [String] })
  options: { id: string; content: string }[];
}

