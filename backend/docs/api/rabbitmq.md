# RabbitMQ Events (Phase 6)

Exchange: `conficircle.events` (topic, durable).
Queue naming: `<producer>.<event>.queue`; DLQ: `<queue>.dlq`.

| Event | Routing key | Producer | Payload (`@conficircle/event-schemas`) |
| --- | --- | --- | --- |
| UserRegistered | `identity.user.registered` | identity | UserRegisteredPayload |
| GuestSessionCreated | `identity.guest.session.created` | identity | GuestSessionCreatedPayload |
| GuestConverted | `identity.guest.converted` | identity | GuestConvertedPayload |
| QuickTipConsumed | `content.quick-tip.consumed` | content | QuickTipConsumedPayload |
| AssessmentCompleted | `assessment.completed` | assessment | AssessmentCompletedPayload |
| VideoProgressUpdated | `progress.video.updated` | progress | VideoProgressUpdatedPayload |
| TopicProgressUpdated | `progress.topic.updated` | progress | TopicProgressUpdatedPayload |

## Delivery + retry semantics

- Envelope: `{eventId, eventType, occurredAt, producer, attempt, payload}`.
- Manual acks; `x-attempt`-style retry counter increments in the envelope.
- After `maxRetries` (default 3) failures the message is published to
  `dlq.<queue>` and acked (no poison-pill loop).
- Consumers must be **idempotent**: resolve `eventId` before applying.
- Important database-bound events MUST use the transactional outbox
  (`OutboxEvent` table written in the same DB transaction; relayed by the
  publisher).

## Planned subscribers (not yet implemented)

| Consumer | Events           | Reaction |
| --- | --- | --- |
| progress | UserRegistered, AssessmentCompleted, QuickTipConsumed | create dashboard rows, record activity, increment daily stats |
| identity | GuestConverted | finalize guest session record |
| content  | (topic publication lifecycle to be defined) | publication state |

No business workflows are wired yet — this is scaffolding only.
