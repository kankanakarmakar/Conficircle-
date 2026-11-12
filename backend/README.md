# ConfCircle Backend

NestJS + PostgreSQL + Redis + RabbitMQ microservices monorepo backing the
existing ConfCircle Flutter app. The Flutter application is untouched; all
backend code lives in `backend/`.

## Quick start (development)

```bash
# 1. Prerequisites: Node.js >= 20 (LTS), pnpm >= 9 (or corepack), Docker
corepack enable                      # provides pnpm 12
cd backend
cp .env.example .env                 # never commit the real .env

# 2. Install dependencies
pnpm install

# 3. Start local infrastructure (PostgreSQL, Redis, RabbitMQ)
docker compose up -d
docker compose ps                    # wait until all three are healthy

# 4. Build everything
pnpm build

# 5. Run each service (different terminals, or `pnpm start` for all)
PORT=3000 pnpm --filter @conficircle/api-gateway start            # gateway  (swagger at /docs)
PORT=3001 pnpm --filter @conficircle/identity-service start
PORT=3002 pnpm --filter @conficircle/content-service start
PORT=3003 pnpm --filter @conficircle/assessment-service start
PORT=3004 pnpm --filter @conficircle/progress-service start

# Health checks
curl http://localhost:3000/health

# Tests
pnpm test
```

## Structure

```
backend/
  apps/
    api-gateway/         # single external entry point, swagger at /docs
    identity-service/    # auth, sessions, guest identity (own DB)
    content-service/     # topics, questions, tips, videos (own DB)
    assessment-service/  # assessments, attempts, server-side scoring (own DB)
    progress-service/    # activity, video/topic progress, analytics (own DB)
  packages/
    contracts/           # cross-service DTO/API types
    event-schemas/       # RabbitMQ event envelopes + payloads
    logger/              # structured JSON logging + redaction
    configuration/       # shared env validation helpers
  infrastructure/
    postgres/            # init script: 4 logical databases
    redis/               # (reserved for tuned config)
    rabbitmq/            # (reserved for definitions)
    monitoring/          # (reserved)
  docs/                  # architecture, database, api, decisions
  scripts/               # helper scripts
  docker-compose.yml     # postgres + redis + rabbitmq, persistent volumes
```

## Technology

| Component        | Choice                              |
| ---------------- | ----------------------------------- |
| Runtime          | Node.js 20 LTS                      |
| Language         | TypeScript 5.6                      |
| Framework        | NestJS 10                           |
| Package manager  | pnpm 12 (workspace)                 |
| Databases        | PostgreSQL 16 (4 logical DBs)       |
| ORM              | Prisma 6 (per-service client)       |
| Cache/coordination | Redis 7                           |
| Message broker   | RabbitMQ 3.13 (topic exchange)      |
| Auth (foundation)| JWT + refresh rotation, bcrypt      |
| Docs             | Swagger (`@nestjs/swagger`)         |
| Testing          | Jest + ts-jest + Supertest          |
| Logging          | Structured JSON (redacts secrets)   |

## Commands

| Task                          | Command |
| ----------------------------- | ------- |
| Install                       | `pnpm install` |
| Build everything              | `pnpm build` |
| Build one app                 | `pnpm build:gateway` (`build:identity`, …) |
| Run tests                     | `pnpm test` |
| Validate all Prisma schemas   | `pnpm -r prisma:validate` |
| Start infra                   | `docker compose up -d` |
| Stop infra (keep data)        | `docker compose down` |
| Stop infra + wipe data        | `docker compose down -v` |
| Tail infra logs               | `docker compose logs -f` |
| Start all services in parallel| `PORT-aware: see scripts/dev.sh` |

## Important notes

- **No production migrations yet.** Prisma schemas are DRAFT (no original
  DBML was found in the repo — see `docs/decisions/0001-sourcing-models.md`).
  Do not run `prisma migrate` until the data model is approved.
- Development host ports are non-standard (14332 / 16379 / 56780 / 15690)
  because this workstation already occupies the defaults. Adjust in `.env`.
- Never commit real secrets; `.gitignore` excludes `.env`.
