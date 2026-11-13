# 0002 — Single shared PostgreSQL database with schema isolation

- Date: 2026-11-12
- Status: Accepted

## Context

The backend originally used four physical databases (`identity_db`,
`content_db`, `assessment_db`, `progress_db`) — one per service. The
product decided to consolidate to ONE PostgreSQL database
(`conficircle_db`) while keeping the microservices architecture intact
(services, HTTP APIs, RabbitMQ events, Redis, gateway all unchanged).

## Decision

1. Keep five independently deployable NestJS services (no merge, no
   modular monolith).
2. Keep one Prisma schema + one generated Prisma client per service.
3. Point all four domain services at `conficircle_db`.
4. Isolate data by PostgreSQL **schema**: `identity`, `content`,
   `assessment`, `progress`. Every Prisma model is tagged with
   `@@schema("<name>")`; the `multiSchema` preview feature (Prisma 6.2.x)
   is enabled.
5. Keep migration history isolated: each service's connection URL sets
   `?schema=<service>` so its `_prisma_migrations` lives inside its own
   schema (they collide in `public` otherwise — all four migrations are
   named `20261112000000_init`).
6. Create least-privilege login roles per service, each granted only its
   own schema (usage/create + CRUD + sequences + default privileges).
   Dev temporarily uses the shared admin credential — documented.
7. Docker Compose initializes `conficircle_db`; an idempotent SQL
   bootstrap creates schemas + roles (runs automatically on a fresh
   volume; `scripts/init-schemas.sh` covers an existing volume).
8. Data at migration time was verified empty (no rows, no tables), so no
   data transfer was required; a backup/rollback procedure is documented
   in `docs/database/setup.md` for future re-runs.

## Consequences

- All data lives in one container/database — simpler ops, single backup.
- Schema-level ownership preserved; cross-service joins remain FORBIDDEN
  in business code (communication stays HTTP + RabbitMQ).
- Prisma note: `node-linker=hoisted` was set in `pnpm-workspace.yaml`
  because the Prisma CLI requires `@prisma/client` and `prisma` to
  resolve as siblings, which pnpm's symlinked store otherwise breaks.
- Prisma clients generate to `apps/<svc>/src/generated/prisma-client`
  (local output per service).
- `prisma migrate dev` requires an interactive TTY; CI uses generated
  SQL (via `prisma migrate diff`) + `prisma migrate deploy`.
