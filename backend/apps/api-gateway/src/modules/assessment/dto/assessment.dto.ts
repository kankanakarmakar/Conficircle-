import { ApiProperty } from "@nestjs/swagger";
import { IsArray, IsNotEmpty, IsString } from "class-validator";

export class AssessmentOptionDto {
  @ApiProperty({ example: "opt-1" })
  id!: string;

  @ApiProperty({ example: "I usually wait until someone asks my opinion directly." })
  text!: string;

  @ApiProperty({ example: 1 })
  orderIndex!: number;
}

export class AssessmentQuestionDto {
  @ApiProperty({ example: "q-1" })
  id!: string;

  @ApiProperty({ example: "When an opportunity arises to speak in a meeting, how do you typically react?" })
  prompt!: string;

  @ApiProperty({ example: 1 })
  orderIndex!: number;

  @ApiProperty({ type: () => [AssessmentOptionDto] })
  options!: AssessmentOptionDto[];
}

export class AssessmentSummaryDto {
  @ApiProperty({ example: "ass-1" })
  id!: string;

  @ApiProperty({ example: "Communication & Decisiveness Assessment" })
  title!: string;

  @ApiProperty({ example: "Evaluate your readiness to contribute in high-visibility group discussions." })
  description!: string;

  @ApiProperty({ example: 5 })
  questionCount!: number;

  @ApiProperty({ example: 10, description: "Estimated completion time in minutes" })
  estimatedTimeMin!: number;
}

export class PublicAssessmentDto extends AssessmentSummaryDto {
  @ApiProperty({ type: () => [AssessmentQuestionDto] })
  questions!: AssessmentQuestionDto[];
}

export class AnswerSubmissionDto {
  @ApiProperty({ example: "q-1" })
  @IsString()
  @IsNotEmpty()
  questionId!: string;

  @ApiProperty({ example: "opt-1" })
  @IsString()
  @IsNotEmpty()
  selectedOptionId!: string;
}

export class SubmitAssessmentDto {
  @ApiProperty({ type: () => [AnswerSubmissionDto] })
  @IsArray()
  answers!: AnswerSubmissionDto[];
}

export class AssessmentResultDto {
  @ApiProperty({ example: "att-879102" })
  attemptId!: string;

  @ApiProperty({ example: 82.5, description: "Score percentage (0-100)" })
  score!: number;

  @ApiProperty({ example: 3, description: "Evaluated confidence level (1-5)" })
  level!: number;

  @ApiProperty({ example: "Level 3: Strategic Contributor" })
  levelTitle!: string;

  @ApiProperty({ example: 50, description: "Confy points awarded" })
  pointsAwarded!: number;

  @ApiProperty({ example: ["Practice speaking during the first 10 minutes of meetings", "Use 3 bullet points to structure updates"] })
  recommendations!: string[];
}

