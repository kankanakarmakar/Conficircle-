/**
 * Thin shared RabbitMQ access layer built on amqplib.
 *
 * Design notes (local foundation only):
 * - Publishers declare the topic exchange `conficircle.events` lazily.
 * - Consumers use manual acks; a retry counter in the envelope is
 *   honored, and messages exceeding max retries are dead-lettered.
 * - Consumers must be idempotent — the envelope carries an eventId.
 * - Business-critical database events must use the transactional
 *   outbox pattern, not direct publish-then-write.
 */
import amqp, { type Channel, type Connection } from "amqplib";
import { createLogger, type Logger } from "@conficircle/logger";
import type { EventEnvelope } from "@conficircle/event-schemas";
import { EVENT_EXCHANGE } from "@conficircle/event-schemas";

export interface ConsumeOptions {
  queue: string;
  /** Routing keys (patterns) bound to the topic exchange. */
  routingKeys: string[];
  deadLetterQueue?: string;
  maxRetries?: number;
  handler: (envelope: EventEnvelope, raw: Buffer) => Promise<void>;
}

export class RabbitMQService {
  private connection?: Connection;
  private channel?: Channel;
  private readonly logger: Logger;
  private readonly rabbitUrl: string;

  constructor(rabbitUrl: string, service: string, logLevel = "info") {
    this.rabbitUrl = rabbitUrl;
    this.logger = createLogger({ service, level: logLevel });
  }

  async start(): Promise<void> {
    if (!this.rabbitUrl) {
      this.logger.warn("RABBITMQ_URL empty — messaging disabled (standalone mode)");
      return;
    }
    if (this.channel) return;
    this.connection = await amqp.connect(this.rabbitUrl);
    this.channel = await this.connection.createChannel();
    await this.channel.assertExchange(EVENT_EXCHANGE, "topic", {
      durable: true,
    });
    this.connection.on("error", (e) => {
      this.channel = undefined;
      this.logger.error("rabbitmq connection error", { error: String(e) });
    });
    this.connection.on("close", () => {
      this.channel = undefined;
    });
    this.logger.info("rabbitmq connected");
  }

  async publish<T>(eventType: string, payload: T, attempt = 0): Promise<void> {
    await this.start();
    if (!this.channel) return; // standalone mode: nothing to do
    const envelope: EventEnvelope<T> = {
      eventId: crypto.randomUUID(),
      eventType: eventType as EventEnvelope<T>["eventType"],
      occurredAt: new Date().toISOString(),
      producer: process.env.SERVICE_NAME ?? "conficircle.content-service",
      attempt,
      payload,
    };
    this.channel.publish(EVENT_EXCHANGE, eventType, Buffer.from(JSON.stringify(envelope)), {
      persistent: true,
      contentType: "application/json",
    });
    this.logger.debug("event published", { eventType, eventId: envelope.eventId });
  }

  /** Creates a queue, binds routing keys, and wires DLQ + manual-ack consumption. */
  async consume(options: ConsumeOptions): Promise<void> {
    await this.start();
    if (!this.channel) return; // standalone mode
    const maxRetries = options.maxRetries ?? 3;
    const dlq = options.deadLetterQueue ?? `${options.queue}.dlq`;

    await this.channel.assertQueue(options.queue, { durable: true });
    for (const key of options.routingKeys) {
      await this.channel.bindQueue(options.queue, EVENT_EXCHANGE, key);
    }
    await this.channel.assertQueue(dlq, { durable: true });
    await this.channel.bindQueue(dlq, EVENT_EXCHANGE, `dlq.${options.queue}`);

    await this.channel.consume(options.queue, async (msg) => {
      if (!msg) return;
      try {
        const envelope = JSON.parse(msg.content.toString("utf8")) as EventEnvelope;
        await options.handler(envelope, msg.content);
        this.channel?.ack(msg);
      } catch (err) {
        const envelope = JSON.parse(msg.content.toString("utf8")) as EventEnvelope;
        const attempt = (envelope.attempt ?? 0) + 1;
        if (attempt >= maxRetries) {
          this.logger.error("message dead-lettered", {
            eventType: envelope.eventType,
            eventId: envelope.eventId,
          });
          await this.publish(`dlq.${options.queue}`, { ...envelope, attempt });
          this.channel?.ack(msg);
        } else {
          this.logger.warn("message failed, requeueing", { attempt });
          this.channel?.nack(msg, false, true);
        }
      }
    });
  }

  async stop(): Promise<void> {
    try {
      await this.channel?.close();
      await this.connection?.close();
    } finally {
      this.channel = undefined;
      this.connection = undefined;
    }
  }
}
