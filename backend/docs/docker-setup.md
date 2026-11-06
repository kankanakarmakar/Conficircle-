# Docker Setup Guide

`backend/docker-compose.yml` (project: `conficircle-backend`):

| Service | Image | Volume | Health check | Host port (dev) |
| --- | --- | --- | --- | --- |
| postgres | postgres:16.2-alpine | postgres-data | `pg_isready` | 127.0.0.1:14332 |
| redis | redis:7.2-alpine (AOF) | redis-data | `redis-cli ping` | 127.0.0.1:16379 |
| rabbitmq | rabbitmq:3.13-management-alpine | rabbitmq-data | `rabbitmq-diagnostics ping` | 127.0.0.1:56780 (AMQP), 15690 (management) |

- All host binds are `127.0.0.1` only — nothing is publicly exposed.
- Credentials come from `backend/.env` (never hardcoded, never committed).
- `infrastructure/postgres/init/01-init-databases.sh` creates
  identity_db, content_db, assessment_db, progress_db on first start.
- Restart policy `unless-stopped` on every service.

Useful commands: see the Commands table in backend/README.md.
