.PHONY: all run help example-sql example-dbt setup up down logs clean run-examples list-examples

all: run

help:
	@echo "Available targets:"
	@echo "  make setup          - Start Docker Compose services"
	@echo "  make run            - Run all examples"
	@echo "  make run-examples   - Execute all SQL examples from examples/ directory"
	@echo "  make list-examples  - List all available SQL examples"
	@echo "  make run-example FILE='Example 2-1...' - Run a specific example file"
	@echo "  make example-sql    - Run basic SQL examples"
	@echo "  make example-dbt    - Run dbt model"
	@echo "  make logs           - Show Docker Compose logs"
	@echo "  make down           - Stop all services"
	@echo "  make clean          - Stop services and remove volumes"

setup: up
	@echo "Waiting for services to be healthy..."
	@sleep 10
	@echo "✓ Services are ready!"
	@echo ""
	@echo "Access points:"
	@echo "  - PostgreSQL: localhost:5433 (user: analytics, password: analytics)"
	@echo ""

up:
	@echo "Starting Docker Compose services..."
	docker compose up -d

down:
	@echo "Stopping Docker Compose services..."
	docker compose down

clean:
	@echo "Cleaning up all services and volumes..."
	docker compose down -v

logs:
	docker compose logs -f

run: example-sql example-dbt
	@echo ""
	@echo "✓ All examples completed!"

example-sql:
	@echo "=== Chapter 2: Data Modeling Examples ==="
	@echo "Running data modeling SQL examples in PostgreSQL..."
	@echo "Initializing example data (idempotent)..."
	@docker compose exec -T postgres psql -U analytics -d analytics_db -f /docker-entrypoint-initdb.d/01-init.sql > /dev/null 2>&1
	@echo ""
	@echo "Books table data:"
	@docker compose exec -T postgres psql -U analytics -d analytics_db -c "SELECT * FROM books LIMIT 4;"
	@echo ""

example-dbt:
	@echo "=== dbt Model Example ==="
	@echo "Running dbt model..."
	@docker compose exec -T dbt dbt run --project-dir /usr/app/dbt --profiles-dir /usr/app
	@echo ""
	@echo "Verifying results:"
	@docker compose exec -T postgres psql -U analytics -d analytics_db -c "SELECT * FROM total_revenue;"
	@echo ""

list-examples:
	@echo "=== Available SQL Examples ==="
	@ls -1 examples/*.sql 2>/dev/null | sed 's|examples/||' | sort || echo "No SQL examples found"
	@echo ""
	@echo "Non-SQL examples:"
	@ls -1 examples/*.{yaml,sh} 2>/dev/null | sed 's|examples/||' | sort || echo "No non-SQL examples found"
	@echo ""

run-example:
	@if [ -z "$(FILE)" ]; then \
		echo "Error: Please specify FILE parameter"; \
		echo "Usage: make run-example FILE='Example 2-1. The books database in a physical model.sql'"; \
		exit 1; \
	fi
	@if [ ! -f "examples/$(FILE)" ]; then \
		echo "Error: File 'examples/$(FILE)' not found"; \
		exit 1; \
	fi
	@echo "=== Running: $(FILE) ==="
	@if echo "$(FILE)" | grep -q '\.sql$$'; then \
		echo "Executing SQL file..."; \
		docker compose exec -T postgres psql -U analytics -d analytics_db < "examples/$(FILE)" 2>&1 | head -50; \
	elif echo "$(FILE)" | grep -q '\.sh$$'; then \
		echo "Executing shell script..."; \
		bash "examples/$(FILE)"; \
	else \
		echo "Displaying file contents:"; \
		cat "examples/$(FILE)"; \
	fi
	@echo ""
	@echo "✓ Completed: $(FILE)"
	@echo ""

run-examples:
	@echo "=== Running All SQL Examples ==="
	@echo ""
	@for file in examples/*.sql; do \
		if [ -f "$$file" ]; then \
			filename=$$(basename "$$file"); \
			echo ">>> Running: $$filename"; \
			docker compose exec -T postgres psql -U analytics -d analytics_db < "$$file" 2>&1 | head -20; \
			echo ""; \
		fi; \
	done
	@echo "✓ All SQL examples completed!"
	@echo ""
	@echo "To run a specific example, use:"
	@echo "  make run-example FILE='Example 2-1. The books database in a physical model.sql'"
	@echo ""
