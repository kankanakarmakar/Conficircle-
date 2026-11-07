import { IsInt, Min } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class VideoProgressDto {
  @ApiProperty({ example: 45, description: 'Current playback position in seconds' })
  @IsInt()
  @Min(0)
  positionSec: number;
}

