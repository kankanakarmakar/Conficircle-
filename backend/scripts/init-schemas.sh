#!/bin/bash
# Applies the single-database bootstrap (schemas + service roles + grants)
# to an ALREADY-initialized postgres volume, where the container's
# docker-entrypoint-initdb.d scripts do not run again.
#
# Idempotent: safe to run repeatedly.
# Requires backend/.env (or the compose environment) for passwords.
# Optionally creates conficircle_db first if it does not exist yet.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

run_psql() {
  if [ -f "$ROOT/.env" ]; then
    node "$ROOT/node_modules/dotenv-cli/cli.js" -e "$ROOT/.env" -- docker exec -i conficircle-postgres psql "$@"
  else
    docker exec -i conficircle-postgres psql "$@"
  fi
}

# 1. Ensure the shared database exists (create only if missing; never drop).
run_psql --username conficircle --dbname postgres -tAc \
  "SELECT 1 FROM pg_database WHERE datname = 'conficircle_db'" | grep -q 1 || \
  run_psql --username conficircle --dbname postgres -c "CREATE DATABASE conficircle_db;"

# 2. Schemas + roles + grants (idempotent SQL).
run_psql --username conficircle --dbname "${POSTGRES_DB:-conficircle_db}" \
  -v identity_password="${IDENTITY_DB_PASSWORD:-}" \
  -v content_password="${CONTENT_DB_PASSWORD:-}" \
  -v assessment_password="${ASSESSMENT_DB_PASSWORD:-}" \
  -v progress_password="${PROGRESS_DB_PASSWORD:-}" \
  -f - < "$ROOT/infrastructure/postgres/init-schemas.sql"
