# Development start
start-dev:
	@echo "🚀 Starting development servers..."
	yarn dev

# Database operations
db-migrate:
	@echo "📦 Running database migrations..."
	cd apps/api && npx prisma migrate dev

db-studio:
	@echo "📊 Opening Prisma Studio..."
	cd apps/api && npx prisma studio

db-reset:
	@echo "⚠️  Resetting database (THIS WILL DELETE ALL DATA)..."
	cd apps/api && npx prisma migrate reset --force

# Building
build-api:
	@echo "🏗️  Building API..."
	cd apps/api && yarn build

build-web:
	@echo "🏗️  Building Web..."
	cd apps/web && yarn build

# Testing
test:
	@echo "🧪 Running tests..."
	yarn test

# Cleanup
clean:
	@echo "🧹 Cleaning up..."
	rm -rf dist/ .next/ node_modules/ apps/*/node_modules/ apps/*/dist/ apps/*/.next/

# Help
help:
	@echo "Investment Broker Platform - Development Commands"
	@echo ""
	@echo "Setup:"
	@echo "  make setup       - Full setup (dependencies + database)"
	@echo "  make install     - Install dependencies"
	@echo ""
	@echo "Development:"
	@echo "  make dev         - Start dev servers (API + Web)"
	@echo "  make start-dev   - Start dev servers"
	@echo ""
	@echo "Database:"
	@echo "  make db-migrate  - Run database migrations"
	@echo "  make db-studio   - Open Prisma Studio"
	@echo "  make db-reset    - Reset database (CAUTION: loses all data)"
	@echo ""
	@echo "Building:"
	@echo "  make build       - Build all apps"
	@echo "  make build-api   - Build API only"
	@echo "  make build-web   - Build Web only"
	@echo ""
	@echo "Testing:"
	@echo "  make test        - Run tests"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean       - Remove all build artifacts"
	@echo ""
	@echo "Info:"
	@echo "  make help        - Show this help message"

.PHONY: help setup install dev start-dev build build-api build-web test clean db-migrate db-studio db-reset
