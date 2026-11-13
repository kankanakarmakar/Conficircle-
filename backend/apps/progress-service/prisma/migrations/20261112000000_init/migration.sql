-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "progress";

-- CreateTable
CREATE TABLE "progress"."VideoProgress" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "videoId" UUID NOT NULL,
    "topicId" UUID NOT NULL,
    "positionSeconds" INTEGER NOT NULL,
    "durationSeconds" INTEGER NOT NULL,
    "completedAt" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "VideoProgress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "progress"."TopicProgress" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "topicId" UUID NOT NULL,
    "completionPercent" INTEGER NOT NULL DEFAULT 0,
    "completedAt" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TopicProgress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "progress"."ActivityEvent" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "eventType" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "occurredAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ActivityEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "progress"."DailyStat" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "date" DATE NOT NULL,
    "questionsAnswered" INTEGER NOT NULL DEFAULT 0,
    "videosWatched" INTEGER NOT NULL DEFAULT 0,
    "topicsCompleted" INTEGER NOT NULL DEFAULT 0,
    "quickTipsConsumed" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "DailyStat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "progress"."OutboxEvent" (
    "id" UUID NOT NULL,
    "eventType" TEXT NOT NULL,
    "routingKey" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "processedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OutboxEvent_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "VideoProgress_userId_updatedAt_idx" ON "progress"."VideoProgress"("userId", "updatedAt");

-- CreateIndex
CREATE UNIQUE INDEX "VideoProgress_userId_videoId_key" ON "progress"."VideoProgress"("userId", "videoId");

-- CreateIndex
CREATE INDEX "TopicProgress_userId_updatedAt_idx" ON "progress"."TopicProgress"("userId", "updatedAt");

-- CreateIndex
CREATE UNIQUE INDEX "TopicProgress_userId_topicId_key" ON "progress"."TopicProgress"("userId", "topicId");

-- CreateIndex
CREATE INDEX "ActivityEvent_userId_occurredAt_idx" ON "progress"."ActivityEvent"("userId", "occurredAt");

-- CreateIndex
CREATE INDEX "ActivityEvent_eventType_idx" ON "progress"."ActivityEvent"("eventType");

-- CreateIndex
CREATE INDEX "DailyStat_userId_date_idx" ON "progress"."DailyStat"("userId", "date");

-- CreateIndex
CREATE UNIQUE INDEX "DailyStat_userId_date_key" ON "progress"."DailyStat"("userId", "date");

-- CreateIndex
CREATE INDEX "OutboxEvent_processedAt_idx" ON "progress"."OutboxEvent"("processedAt");
