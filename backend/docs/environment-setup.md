# Environment Setup

1. Requirements: Node.js >= 20, pnpm >= 9 (corepack enable), Docker with
   Compose v2.
2. `cd backend`, `cp .env.example .env`, edit at minimum:
   - `JWT_SECRET`, `JWT_REFRESH_SECRET` (`openssl rand -base64 48`)
   - `POSTGRES_PASSWORD`, `RABBITMQ_PASSWORD` (replace dev defaults)
3. `docker compose up -d` — creates the four logical databases on first
   start (backend/infrastructure/postgres/init).
4. `pnpm install`, then `pnpm build`.
5. Non-standard host ports: this workstation already occupies 5432, 6379,
   5672, so compose maps 14332 (postgres), 16379 (redis), 56780 + 15690
   (rabbit). Change via `.env` only; container-internal ports stay
   standard.
6. Services read `DATABASE_URL`-style vars from `.env` via
   `dotenv-cli` (scripts in each app's package.json use
   `dotenv -e ../../.env -- ...`).
