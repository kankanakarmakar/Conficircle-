# Database Ownership Matrix (Draft)

Original business data model (DBML) was not available in the repository.
Service ownership below was derived from the service responsibility
definitions; model names are provisional.

| Database | Owner | Tables (draft) | Notes |
| --- | --- | --- | --- |
| identity_db | identity-service | users, refresh_sessions, guest_sessions | auth + guest conversion |
| content_db | content-service | topics, questions, question_options, quick_tips, video_resources, learning_resources, content_publications | correctness data stays server-side |
| assessment_db | assessment-service | assessments, assessment_questions, assessment_options, assessment_attempts, attempt_responses, outbox_event | server-side scoring only |
| progress_db | progress-service | video_progress, topic_progress, activity_events, daily_stat | event-sourced-ish activity log |
| — | api-gateway | none | routes, does not own data |

Shared conventions (draft):

- UUID primary keys, `createdAt`/`updatedAt` timestamps.
- Indexes on hot lookup paths (user + date/topic, published + order).
- Unique constraints: user email, refresh token hash, (user, video),
  (user, topic), (user, date), (user, assessment, startedAt).
- Foreign keys only within a service.
- Every domain DB hosts a `OutboxEvent` table (transactional outbox).

Status: **DRAFT — do not run `prisma migrate` until the data model is
reviewed and approved.** The original repository contains no DBML source
to reconcile against.
