# Database Ownership Matrix (single-database, schema-isolated)

Original business data model (DBML) was not available in the repository
(see docs/decisions/0001-sourcing-models.md). Model names are provisional.
Since 2026-11-12 all services share ONE PostgreSQL database
(`conficircle_db`) but own separate PostgreSQL **schemas**.

| PostgreSQL schema | Owner service | Tables (draft) | Notes |
| --- | --- | --- | --- |
| identity | identity-service | User, RefreshSession, GuestSession, OutboxEvent | auth + guest conversion |
| content | content-service | Topic, Question, QuestionOption, QuickTip, VideoResource, LearningResource, ContentPublication, OutboxEvent | correctness data stays server-side |
| assessment | assessment-service | Assessment, AssessmentQuestion, AssessmentOption, AssessmentAttempt, AttemptResponse, OutboxEvent | server-side scoring only |
| progress | progress-service | VideoProgress, TopicProgress, ActivityEvent, DailyStat, OutboxEvent | activity log + stats |
| (none) | api-gateway | none | routes; owns no data |

Shared conventions:

- One database, four schemas; every model tagged `@@schema("<name>")`.
- Each schema contains its own `OutboxEvent` (transactional outbox) and
  its own `_prisma_migrations` history table.
- UUID primary keys, createdAt/updatedAt timestamps, hot-path indexes,
  unique constraints (user email, refresh token hash, user+video,
  user+topic, user+date, user+assessment+startedAt).
- Foreign keys only within the same schema; references to users in other
  schemas are plain UUIDs enforced at the application layer.
- Prisma clients are per-service, generated to each app's
  `src/generated/prisma-client` (never shared).
- Roles: `identity_service_user`, `content_service_user`,
  `assessment_service_user`, `progress_service_user` — each restricted
  to its own schema.

Status: **DRAFT models — reconcile against the approved data model before
production.**
