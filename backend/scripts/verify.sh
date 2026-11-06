#!/usr/bin/env bash
# Verifies the foundation: build -> schema validate -> tests.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "== pnpm workspace" && pnpm m ls --depth -1 | head -20
echo "== build" && pnpm build
echo "== prisma schema validation" && pnpm -r prisma:validate
echo "== tests" && pnpm test
echo "verify done"
