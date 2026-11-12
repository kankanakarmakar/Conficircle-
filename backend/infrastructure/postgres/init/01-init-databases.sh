#!/bin/bash
# Creates the four logical databases owned by each microservice.
# Runs once on first start of the postgres container (mounted in
# /docker-entrypoint-initdb.d by docker-compose.yml).
set -euo pipefail

for db in identity_db content_db assessment_db progress_db; do
  echo "Creating database $db (if not exists)..."
  psql \
    --username "$POSTGRES_USER" \
    --dbname "$POSTGRES_DB" \
    -tAc "SELECT 1 FROM pg_database WHERE datname = '$db'" | grep -q 1 || \
  psql \
    --username "$POSTGRES_USER" \
    --dbname "$POSTGRES_DB" \
    -c "CREATE DATABASE $db;"
  psql \
    --username "$POSTGRES_USER" \
    --dbname "$POSTGRES_DB" \
    -c "REVOKE ALL ON DATABASE $db FROM PUBLIC;"
done
