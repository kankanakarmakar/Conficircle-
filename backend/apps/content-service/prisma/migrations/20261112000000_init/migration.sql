-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "content";

-- CreateEnum
CREATE TYPE "content"."DifficultyLevel" AS ENUM ('beginner', 'intermediate', 'advanced');

-- CreateTable
CREATE TABLE "content"."Topic" (
    "id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "difficultyLevel" "content"."DifficultyLevel" NOT NULL DEFAULT 'beginner',
    "orderIndex" INTEGER NOT NULL,
    "isPublished" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Topic_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "content"."Question" (
    "id" UUID NOT NULL,
    "topicId" UUID NOT NULL,
    "prompt" TEXT NOT NULL,
    "difficultyLevel" "content"."DifficultyLevel" NOT NULL DEFAULT 'beginner',
    "orderIndex" INTEGER NOT NULL,
    "isPublished" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Question_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "content"."QuestionOption" (
    "id" UUID NOT NULL,
    "questionId" UUID NOT NULL,
    "text" TEXT NOT NULL,
    "orderIndex" INTEGER NOT NULL,
    "isCorrect" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "QuestionOption_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "content"."QuickTip" (
    "id" UUID NOT NULL,
    "topicId" UUID,
    "content" TEXT NOT NULL,
    "isPublished" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "QuickTip_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "content"."VideoResource" (
    "id" UUID NOT NULL,
    "topicId" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "durationSeconds" INTEGER,
    "isPublished" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "VideoResource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "content"."LearningResource" (
    "id" UUID NOT NULL,
    "topicId" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LearningResource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "content"."ContentPublication" (
    "id" UUID NOT NULL,
    "topicId" UUID NOT NULL,
    "status" TEXT NOT NULL,
    "publishedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ContentPublication_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "content"."OutboxEvent" (
    "id" UUID NOT NULL,
    "eventType" TEXT NOT NULL,
    "routingKey" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "processedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OutboxEvent_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Topic_isPublished_orderIndex_idx" ON "content"."Topic"("isPublished", "orderIndex");

-- CreateIndex
CREATE INDEX "Topic_difficultyLevel_idx" ON "content"."Topic"("difficultyLevel");

-- CreateIndex
CREATE INDEX "Question_topicId_orderIndex_idx" ON "content"."Question"("topicId", "orderIndex");

-- CreateIndex
CREATE INDEX "Question_difficultyLevel_idx" ON "content"."Question"("difficultyLevel");

-- CreateIndex
CREATE INDEX "QuestionOption_questionId_orderIndex_idx" ON "content"."QuestionOption"("questionId", "orderIndex");

-- CreateIndex
CREATE INDEX "QuickTip_topicId_idx" ON "content"."QuickTip"("topicId");

-- CreateIndex
CREATE INDEX "VideoResource_topicId_idx" ON "content"."VideoResource"("topicId");

-- CreateIndex
CREATE INDEX "LearningResource_topicId_idx" ON "content"."LearningResource"("topicId");

-- CreateIndex
CREATE INDEX "ContentPublication_topicId_status_idx" ON "content"."ContentPublication"("topicId", "status");

-- CreateIndex
CREATE INDEX "OutboxEvent_processedAt_idx" ON "content"."OutboxEvent"("processedAt");

-- AddForeignKey
ALTER TABLE "content"."Question" ADD CONSTRAINT "Question_topicId_fkey" FOREIGN KEY ("topicId") REFERENCES "content"."Topic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "content"."QuestionOption" ADD CONSTRAINT "QuestionOption_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "content"."Question"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "content"."QuickTip" ADD CONSTRAINT "QuickTip_topicId_fkey" FOREIGN KEY ("topicId") REFERENCES "content"."Topic"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "content"."VideoResource" ADD CONSTRAINT "VideoResource_topicId_fkey" FOREIGN KEY ("topicId") REFERENCES "content"."Topic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "content"."LearningResource" ADD CONSTRAINT "LearningResource_topicId_fkey" FOREIGN KEY ("topicId") REFERENCES "content"."Topic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
