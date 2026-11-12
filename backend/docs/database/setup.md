# Database Setup Guide

One PostgreSQL 16 container, four logical databases (one per service, per
database-per-service rule):

- identity_db — owned by identity-service (`IDENTITY_DATABASE_URL`)
- content_db — owned by content-service (`CONTENT_DATABASE_URL`)
- assessment_db — owned by assessment-service (`ASSESSMENT_DATABASE_URL`)
- progress_db — owned by progress-service (`PROGRESS_DATABASE_URL`)

Created automatically on first container start by
`infrastructure/postgres/init/01-init-databases.sh`.

Per-service clients (never shared): each domain service has its own
`prisma/schema.prisma` and runs its own `prisma generate`. Schemas are
DRAFT — migrations are intentionally not generated yet (see
docs/decisions/0001-sourcing-models.md). Validation:

```bash
pnpm -r prisma:validate
```

When a data model is approved, generate migrations per service, e.g.:

```bash
cd apps/identity-service
dotenv -e ../../.env -- prisma migrate dev --schema prisma/schema.prisma
```
