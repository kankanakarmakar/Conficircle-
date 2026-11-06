#!/usr/bin/env bash
# Starts all five services in parallel with per-port env injection.
# Requires: pnpm install && pnpm build and infra up (docker compose up -d).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

declare -A PORTS=(
  [api-gateway]=3000
  [identity-service]=3001
  [content-service]=3002
  [assessment-service]=3003
  [progress-service]=3004
)

dotenv_bin="$ROOT/node_modules/dotenv-cli/cli.js"

for app in "${!PORTS[@]}"; do
  echo "starting $app on :${PORTS[$app]}"
  (cd "apps/$app" && \
    PORT="${PORTS[$app]}" node "$dotenv_bin" -e "$ROOT/.env" -- node dist/main.js) &
done

wait
