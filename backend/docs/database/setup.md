# Database Setup Guide — Single Shared Database (v2)

> **Architecture change (2026-11-12):** the backend moved from four
> separate databases (`identity_db`, `content_db`, `assessment_db`,
> `progress_db`) to ONE shared PostgreSQL database
> (`conficircle_db`) with **per-service schema isolation**. The
> microservice boundaries did NOT change — see
> `docs/decisions/0002-single-database-migration.md`.

## Layout

```text
PostgreSQL Server (container conficircle-postgres)
└── conficircle_db
    ├── identity    ← owned by identity-service    (User, RefreshSession, GuestSession, OutboxEvent)
    ├── content     ← owned by content-service     (Topic, Question, QuestionOption, QuickTip,
    │                                               VideoResource, LearningResource,
    │                                               ContentPublication, OutboxEvent)
    ├── assessment  ← owned by assessment-service  (Assessment, AssessmentQuestion, AssessmentOption,
    │                                               AssessmentAttempt, AttemptResponse, OutboxEvent)
    └── progress    ← owned by progress-service    (VideoProgress, TopicProgress, ActivityEvent,
                                                    DailyStat, OutboxEvent)
```

Each schema also holds its OWN `_prisma_migrations` table — migration
history is independent per service (achieved via the `?schema=<service>`
URL parameter on each service's connection).

## Environment variables

One shared URL (root `.env`):

```env
DATABASE_URL=postgresql://conficircle:***@localhost:14332/conficircle_db?schema=public
```

Each service's Prisma CLI loads its own `apps/<service>/prisma/.env`
which appends `?schema=<service>` — this keeps `_prisma_migrations`
history separated per service. The old per-service
`*_DATABASE_URL` variables no longer exist.

The old four databases (which contained **no data** — verified empty at
migration time) are no longer used; they may be dropped manually:
`DROP DATABASE identity_db;` etc.

## Service roles (least privilege)

Four PostgreSQL login roles, each limited to its own schema:

| Role | Schema | Access |
| --- | --- | --- |
| `identity_service_user` | identity | USAGE/CREATE + CRUD on tables/sequences |
| `content_service_user` | content | same |
| `assessment_service_user` | assessment | same |
| `progress_service_user` | progress | same |

No role can read/modify another service's schema (verified). Roles are
created by `infrastructure/postgres/init-schemas.sql` (idempotent),
wired from `.env` passwords (`*_DB_PASSWORD`).

**Known dev limitation:** development currently runs services with the
shared administrative credential (`conficircle`). Production must use
the per-service roles; a TODO tracks wiring role-specific URLs into
service runtime config.

## First-time setup

```bash
docker compose up -d              # starts postgres; POSTGRES_DB=conficircle_db
./scripts/init-schemas.sh         # creates 4 schemas + roles (idempotent)
pnpm db:migrate:all               # applies each service's migrations
```

For a FRESH volume, compose auto-runs
`infrastructure/postgres/init/01-init-databases.sh` (same SQL) on first
start — no manual step needed.

## Migration commands

```bash
pnpm db:generate                  # generate all 4 Prisma clients
pnpm db:migrate:identity          # apply identity-service migrations
pnpm db:migrate:content
pnpm db:migrate:assessment
pnpm db:migrate:progress
pnpm db:migrate:all               # all four, deterministic order
```

Rules:

- Never `prisma migrate reset` against an existing database.
- Migration history tables are per-schema; services never touch another
  service's history.
- Deterministic order: identity → content → assessment → progress.

## Backup / restore

```bash
# Full backup of the shared database (all schemas)
docker exec conficircle-postgres pg_dump -U conficircle -d conficircle_db \
  > backup-conficircle-db.sql

# Per-schema backup (example: identity)
docker exec conficircle-postgres pg_dump -U conficircle -d conficircle_db \
  --schema=identity > backup-identity-schema.sql

# Restore (into a fresh database)
docker exec -i conficircle-postgres psql -U conficircle -d conficircle_db \
  < backup-conficircle-db.sql
```

## Rollback procedure (to the old multi-database architecture)

1. `pg_dump` `conficircle_db` (full backup).
2. Recreate the four old databases (`identity_db`, …).
3. Restore each schema's dump with `pg_restore --schema=<name>` mapped
   to its old database.
4. Revert Prisma schemas (git history keeps the pre-migration versions)
   and `.env` per-service URLs.
5. Services remain compatible either way because no business code
   touches another service's schema.

## Data-preservation note

At migration time the previous `identity_db` (the only surviving old
database) contained **zero tables and zero rows**; all development data
was empty. Nothing was destroyed. If real data had existed, the plan in
`docs/decisions/0002-single-database-migration.md` (backup → schema
transfer via `pg_dump --schema` + row-count verification) would apply.
