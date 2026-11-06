/**
 * Cross-service API and DTO contracts for ConfCircle.
 *
 * These types describe the shape of data exchanged between the API Gateway
 * and the domain microservices. Because the original DBML schema was not
 * present in the repository (see docs/decisions/0001-sourcing-models.md),
 * these contracts are DRAFT representations derived from the stated service
 * responsibilities and must be revised against approved data models.
 */

export type Uuid = string;
export type ISODate = string;

export enum UserRole {
  USER = "user",
  ADMIN = "admin",
}

// ---------------- Identity ----------------

export interface RegisterUserDto {
  email: string;
  password: string;
  displayName: string;
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface AuthTokensDto {
  accessToken: string;
  refreshToken: string;
  accessTokenExpiresAt: ISODate;
}

export interface PublicUserDto {
  id: Uuid;
  email: string;
  displayName: string;
  role: UserRole;
  isGuest: boolean;
  createdAt: ISODate;
}

// ---------------- Content ----------------

export interface TopicDto {
  id: Uuid;
  title: string;
  description?: string;
  difficultyLevel: "beginner" | "intermediate" | "advanced";
  isPublished: boolean;
  orderIndex: number;
}

export interface QuestionDto {
  id: Uuid;
  topicId: Uuid;
  prompt: string;
  difficultyLevel: "beginner" | "intermediate" | "advanced";
  orderIndex: number;
}

export interface QuickTipDto {
  id: Uuid;
  topicId?: Uuid;
  content: string;
}

export interface VideoResourceDto {
  id: Uuid;
  topicId: Uuid;
  title: string;
  url: string;
  durationSeconds?: number;
}

// ---------------- Assessment ----------------

/** Public view of an assessment question — never includes correctness data. */
export interface PublicAssessmentQuestionDto {
  id: Uuid;
  assessmentId: Uuid;
  prompt: string;
  orderIndex: number;
  options: Array<{ id: Uuid; text: string; orderIndex: number }>;
}

export interface SubmitAssessmentResponseDto {
  attemptId: Uuid;
  questionId: Uuid;
  selectedOptionId: Uuid;
}

/** Returned only as a summary — never raw scoring internals. */
export interface AssessmentAttemptResultDto {
  attemptId: Uuid;
  score: number;
  totalQuestions: number;
  completedAt: ISODate | null;
}

// ---------------- Progress ----------------

export interface RecordVideoProgressDto {
  userId: Uuid;
  videoId: Uuid;
  topicId: Uuid;
  positionSeconds: number;
  durationSeconds: number;
}

export interface DailyStatsDto {
  userId: Uuid;
  date: ISODate;
  questionsAnswered: number;
  videosWatched: number;
  topicsCompleted: number;
}
