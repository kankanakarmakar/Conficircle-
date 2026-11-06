/**
 * Publisher module — wraps RabbitMQService for domain events that the
 * service emits. Critical events should go through a transactional
 * outbox before publishing; the outbox table lives in each service's
 * own database (outbox_events model in the DRAFT Prisma schemas).
 */
import { Module } from "@nestjs/common";

export const RABBIT_MQ_SERVICE = Symbol("RABBIT_MQ_SERVICE");

@Module({})
export class PublisherModule {}
