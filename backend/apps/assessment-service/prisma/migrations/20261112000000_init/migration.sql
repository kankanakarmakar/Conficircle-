-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "assessment";

-- CreateEnum
CREATE TYPE "assessment"."DifficultyLevel" AS ENUM ('beginner', 'intermediate', 'advanced');

-- CreateTable
CREATE TABLE "assessment"."Assessment" (
    "id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "difficultyLevel" "assessment"."DifficultyLevel" NOT NULL DEFAULT 'beginner',
    "isPublished" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Assessment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assessment"."AssessmentQuestion" (
    "id" UUID NOT NULL,
    "assessmentId" UUID NOT NULL,
    "prompt" TEXT NOT NULL,
    "orderIndex" INTEGER NOT NULL,

    CONSTRAINT "AssessmentQuestion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assessment"."AssessmentOption" (
    "id" UUID NOT NULL,
    "questionId" UUID NOT NULL,
    "text" TEXT NOT NULL,
    "orderIndex" INTEGER NOT NULL,
    "isCorrect" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "AssessmentOption_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assessment"."AssessmentAttempt" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "assessmentId" UUID NOT NULL,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),
    "score" INTEGER,

    CONSTRAINT "AssessmentAttempt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assessment"."AttemptResponse" (
    "id" UUID NOT NULL,
    "attemptId" UUID NOT NULL,
    "questionId" UUID NOT NULL,
    "selectedOptionId" UUID NOT NULL,
    "respondedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AttemptResponse_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assessment"."OutboxEvent" (
    "id" UUID NOT NULL,
    "attemptId" UUID NOT NULL,
    "eventType" TEXT NOT NULL,
    "routingKey" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "processedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OutboxEvent_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Assessment_isPublished_idx" ON "assessment"."Assessment"("isPublished");

-- CreateIndex
CREATE INDEX "AssessmentQuestion_assessmentId_orderIndex_idx" ON "assessment"."AssessmentQuestion"("assessmentId", "orderIndex");

-- CreateIndex
CREATE INDEX "AssessmentOption_questionId_orderIndex_idx" ON "assessment"."AssessmentOption"("questionId", "orderIndex");

-- CreateIndex
CREATE INDEX "AssessmentAttempt_userId_assessmentId_idx" ON "assessment"."AssessmentAttempt"("userId", "assessmentId");

-- CreateIndex
CREATE UNIQUE INDEX "AssessmentAttempt_userId_assessmentId_startedAt_key" ON "assessment"."AssessmentAttempt"("userId", "assessmentId", "startedAt");

-- CreateIndex
CREATE INDEX "AttemptResponse_attemptId_idx" ON "assessment"."AttemptResponse"("attemptId");

-- CreateIndex
CREATE INDEX "OutboxEvent_processedAt_idx" ON "assessment"."OutboxEvent"("processedAt");

-- AddForeignKey
ALTER TABLE "assessment"."AssessmentQuestion" ADD CONSTRAINT "AssessmentQuestion_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES "assessment"."Assessment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assessment"."AssessmentOption" ADD CONSTRAINT "AssessmentOption_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "assessment"."AssessmentQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assessment"."AssessmentAttempt" ADD CONSTRAINT "AssessmentAttempt_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES "assessment"."Assessment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assessment"."AttemptResponse" ADD CONSTRAINT "AttemptResponse_attemptId_fkey" FOREIGN KEY ("attemptId") REFERENCES "assessment"."AssessmentAttempt"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assessment"."AttemptResponse" ADD CONSTRAINT "AttemptResponse_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "assessment"."AssessmentQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assessment"."OutboxEvent" ADD CONSTRAINT "OutboxEvent_attemptId_fkey" FOREIGN KEY ("attemptId") REFERENCES "assessment"."AssessmentAttempt"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
