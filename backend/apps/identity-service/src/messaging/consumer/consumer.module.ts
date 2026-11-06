/**
 * Consumer module — hosts idempotent event handlers subscribed by this
 * service. Each handler resolves its own eventId before applying
 * changes (see docs/rabbitmq.md for the dedup strategy).
 */
import { Module } from "@nestjs/common";

@Module({})
export class ConsumerModule {}
