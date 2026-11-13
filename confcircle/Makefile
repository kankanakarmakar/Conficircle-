.PHONY: dev build test test-e2e test-unit migrate seed docker-up docker-down docker-logs generate-openapi lint clean help

# Default
help:
	@echo "ConfCircle — Available Make targets:"
	@echo "  dev              Start API in watch mode (requires .env)"
	@echo "  build            Compile TypeScript"
	@echo "  test             Run all unit tests"
	@echo "  test-e2e         Run end-to-end tests"
	@echo "  test-unit        Run unit tests only"
	@echo "  migrate          Run Prisma migrations"
	@echo "  seed             Seed the database"
	@echo "  docker-up        Start all Docker services"
	@echo "  docker-down      Stop all Docker services"
	@echo "  docker-logs      Follow Docker logs"
	@echo "  generate-openapi Export OpenAPI spec"
	@echo "  lint             Run ESLint"
	@echo "  clean            Remove build artifacts"

# Development
dev:
	cd apps/api && npm run start:dev

build:
	cd apps/api && npm run build

# Testing
test: test-unit

test-unit:
	cd apps/api && npm run test -- --passWithNoTests

test-e2e:
	cd apps/api && npm run test:e2e

# Database
migrate:
	cd apps/api && npx prisma migrate deploy --schema=../../prisma/schema.prisma

migrate-dev:
	cd apps/api && npx prisma migrate dev --schema=../../prisma/schema.prisma

seed:
	cd apps/api && npx ts-node ../../prisma/seed.ts

reset-db:
	cd apps/api && npx prisma migrate reset --schema=../../prisma/schema.prisma --force

# Docker
docker-up:
	docker compose up -d postgres redis
	@echo "Waiting for services to be healthy..."
	@sleep 5
	@echo "Services ready. Run 'make migrate && make seed' to initialize DB."

docker-up-all:
	docker compose up -d

docker-down:
	docker compose down

docker-down-volumes:
	docker compose down -v

docker-logs:
	docker compose logs -f

docker-status:
	docker compose ps

# OpenAPI
generate-openapi:
	cd apps/api && npm run build && node -e "const app = require('./dist/main'); app.generateOpenApi()" > ../../packages/api-contract/openapi.json
	@echo "OpenAPI spec written to packages/api-contract/openapi.json"

# Linting
lint:
	cd apps/api && npx eslint src --ext .ts

lint-fix:
	cd apps/api && npx eslint src --ext .ts --fix

# Clean
clean:
	cd apps/api && rm -rf dist node_modules/.cache

# CI entrypoint (used by CI and 'make test' requirement from spec)
ci: docker-up migrate seed test
	@echo "CI pipeline complete."

