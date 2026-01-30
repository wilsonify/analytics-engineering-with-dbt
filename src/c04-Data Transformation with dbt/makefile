.PHONY: all run help setup up down logs clean run-examples list-examples run-example example-dbt example-analyses

all: run

help:
	@echo "Available targets:"
	@echo "  make setup          - Start Docker Compose services"
	@echo "  make run            - Run all examples"
	@echo "  make run-examples   - Execute dbt seeds, models, tests, and analyses"
	@echo "  make list-examples  - List all available example files"
	@echo "  make run-example FILE='models/...sql' - Run a specific example file"
	@echo "  make example-dbt    - Run dbt build (seeds/models/tests)"
	@echo "  make example-analyses - Compile analyses files"
	@echo "  make logs           - Show Docker Compose logs"
	@echo "  make down           - Stop all services"
	@echo "  make clean          - Stop services and remove volumes"

setup: up
	@echo "Waiting for services to be healthy..."
	@sleep 10
	@echo "✓ Services are ready!"
	@echo "Installing dbt packages..."
	@docker compose exec -T dbt dbt deps --project-dir /usr/app/dbt
	@echo ""
	@echo "Access points:"
	@echo "  - PostgreSQL: localhost:5434 (user: analytics, password: analytics)"
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

run: run-examples
	@echo ""
	@echo "✓ All examples completed!"

example-dbt:
	@echo "=== Chapter 4: Data Transformation with dbt ==="
	@echo "Running dbt seeds, models, and tests..."
	@docker compose exec -T dbt dbt build --project-dir /usr/app/dbt --profiles-dir /usr/app
	@echo ""

example-analyses:
	@echo "=== Analyses ==="
	@echo "Compiling analyses..."
	@docker compose exec -T dbt dbt compile --project-dir /usr/app/dbt --profiles-dir /usr/app --select path:analyses
	@echo ""

list-examples:
	@echo "=== Available Examples ==="
	@echo "Models:"
	@find examples/models -type f -name "*.sql" 2>/dev/null | sed 's|examples/||' | sort || echo "No model examples found"
	@echo ""
	@echo "Tests:"
	@find examples/tests -type f -name "*.sql" 2>/dev/null | sed 's|examples/||' | sort || echo "No test examples found"
	@echo ""
	@echo "Analyses:"
	@find examples/analyses -type f -name "*.sql" 2>/dev/null | sed 's|examples/||' | sort || echo "No analysis examples found"
	@echo ""
	@echo "Seeds:"
	@find examples/seeds -type f -name "*.csv" 2>/dev/null | sed 's|examples/||' | sort || echo "No seed examples found"
	@echo ""

run-example:
	@if [ -z "$(FILE)" ]; then \
		echo "Error: Please specify FILE parameter"; \
		echo "Usage: make run-example FILE='models/marts/core/fct_orders.sql'"; \
		exit 1; \
	fi
	@if [ ! -f "examples/$(FILE)" ]; then \
		echo "Error: File 'examples/$(FILE)' not found"; \
		exit 1; \
	fi
	@echo "=== Running: $(FILE) ==="
	@if echo "$(FILE)" | grep -q '^models/'; then \
		echo "Executing model..."; \
		docker compose exec -T dbt dbt run --project-dir /usr/app/dbt --profiles-dir /usr/app --select path:$(FILE); \
	elif echo "$(FILE)" | grep -q '^tests/'; then \
		echo "Executing test..."; \
		docker compose exec -T dbt dbt test --project-dir /usr/app/dbt --profiles-dir /usr/app --select path:$(FILE); \
	elif echo "$(FILE)" | grep -q '^seeds/'; then \
		echo "Executing seed..."; \
		docker compose exec -T dbt dbt seed --project-dir /usr/app/dbt --profiles-dir /usr/app --select path:$(FILE); \
	elif echo "$(FILE)" | grep -q '^analyses/'; then \
		echo "Compiling analysis..."; \
		docker compose exec -T dbt dbt compile --project-dir /usr/app/dbt --profiles-dir /usr/app --select path:$(FILE); \
	else \
		echo "Displaying file contents:"; \
		cat "examples/$(FILE)"; \
	fi
	@echo ""
	@echo "✓ Completed: $(FILE)"
	@echo ""

run-examples:
	@echo "=== Running All dbt Examples ==="
	@echo ""
	@$(MAKE) setup
	@$(MAKE) example-dbt
	@$(MAKE) example-analyses
