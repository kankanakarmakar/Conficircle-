/**
 * Shared RabbitMQ event contracts (payload schemas + routing keys)
 * for ConfCircle event-driven communication.
 *
 * Each event is delivered on the `conficircle.events` topic exchange.
 * Consumers must be idempotent; publishers should use the outbox
 * pattern for events tied to database writes (see docs/rabbitmq.md).
 */

export const EVENT_EXCHANGE = "conficircle.events";

export const EVENT_ROUTING_KEYS = {
  USER_REGISTERED: "identity.user.registered",
  GUEST_SESSION_CREATED: "identity.guest.session.created",
  GUEST_CONVERTED: "identity.guest.converted",
  QUICK_TIP_CONSUMED: "content.quick-tip.consumed",
  ASSESSMENT_COMPLETED: "assessment.completed",
  VIDEO_PROGRESS_UPDATED: "progress.video.updated",
  TOPIC_PROGRESS_UPDATED: "progress.topic.updated",
} as const;

export type EventRoutingKey = (typeof EVENT_ROUTING_KEYS)[keyof typeof EVENT_ROUTING_KEYS];

export interface EventEnvelope<T = Record<string, never>> {
  /** UUIDv4 for idempotent consumption. */
  eventId: string;
  eventType: EventRoutingKey;
  occurredAt: string;
  producer: string;
  /** Retries already attempted before dead-lettering. */
  attempt: number;
  payload: T;
}

export interface UserRegisteredPayload {
  userId: string;
  email: string;
  displayName: string;
  registeredAt: string;
}

export interface GuestSessionCreatedPayload {
  guestSessionId: string;
  anonymousId: string;
  createdAt: string;
}

export interface GuestConvertedPayload {
  guestSessionId: string;
  newUserId: string;
  convertedAt: string;
}

export interface QuickTipConsumedPayload {
  userId: string;
  quickTipId: string;
  consumedAt: string;
}

export interface AssessmentCompletedPayload {
  userId: string;
  attemptId: string;
  assessmentId: string;
  score: number;
  totalQuestions: number;
  completedAt: string;
}

export interface VideoProgressUpdatedPayload {
  userId: string;
  videoId: string;
  topicId: string;
  positionSeconds: number;
  durationSeconds: number;
  updatedAt: string;
}

export interface TopicProgressUpdatedPayload {
  userId: string;
  topicId: string;
  completionPercent: number;
  updatedAt: string;
}

export interface EventPayloadMap {
  "identity.user.registered": UserRegisteredPayload;
  "identity.guest.session.created": GuestSessionCreatedPayload;
  "identity.guest.converted": GuestConvertedPayload;
  "content.quick-tip.consumed": QuickTipConsumedPayload;
  "assessment.completed": AssessmentCompletedPayload;
  "progress.video.updated": VideoProgressUpdatedPayload;
  "progress.topic.updated": TopicProgressUpdatedPayload;
}
