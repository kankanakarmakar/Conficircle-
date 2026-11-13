#!/bin/bash
# First-boot initialization of the SHARED database architecture.
# conficircle_db itself is created by POSTGRES_DB in docker-compose.yml;
# this script adds the four per-service schemas + least-privilege roles.
# Runs automatically only on the FIRST init of the postgres volume;
# for an existing volume run backend/scripts/init-schemas.sh instead.
# Idempotent: the same statements as infrastructure/postgres/init-schemas.sql.
set -euo pipefail

for schema in identity content assessment progress; do
  echo "Creating schema $schema (if not exists)..."
  psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
    -c "CREATE SCHEMA IF NOT EXISTS $schema;"
done

echo "Creating least-privilege service roles and grants..."
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
  -v ON_ERROR_STOP=0 \
  -v identity_password="${IDENTITY_DB_PASSWORD:-}" \
  -v content_password="${CONTENT_DB_PASSWORD:-}" \
  -v assessment_password="${ASSESSMENT_DB_PASSWORD:-}" \
  -v progress_password="${PROGRESS_DB_PASSWORD:-}" \
  -f /docker-entrypoint-initdb.d/init-schemas.sql
