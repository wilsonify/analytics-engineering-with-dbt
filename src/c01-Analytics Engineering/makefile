.PHONY: all run help example-sql example-airflow example-dbt setup up down logs clean

all: run

help:
	@echo "Available targets:"
	@echo "  make setup          - Start Docker Compose services"
	@echo "  make run            - Run all examples"
	@echo "  make example-sql    - Run SQL ETL procedure"
	@echo "  make example-airflow - Show Airflow DAG info"
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
	@echo "  - PostgreSQL: localhost:5432 (user: analytics, password: analytics)"
	@echo "  - Airflow UI: http://localhost:8080 (user: admin, password: admin)"
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

run: example-sql example-dbt example-airflow
	@echo ""
	@echo "✓ All examples completed!"

example-sql:
	@echo "=== Example 1-1: SQL ETL Procedure ==="
	@echo "Running ETL procedure in PostgreSQL..."
	@docker compose exec -T postgres psql -U analytics -d analytics_db -c "\
		BEGIN; \
		CREATE TEMP TABLE IF NOT EXISTS temp_etl AS SELECT * FROM source_table WHERE id NOT IN (SELECT id FROM target_table WHERE id <= 4); \
		UPDATE temp_etl SET column1 = UPPER(column1), column2 = column2 * 2; \
		INSERT INTO target_table (column1, column2) SELECT column1, column2 FROM temp_etl; \
		COMMIT;" > /dev/null 2>&1
	@echo "✓ ETL completed"
	@echo ""
	@echo "Source data:"
	@docker compose exec -T postgres psql -U analytics -d analytics_db -c "SELECT * FROM source_table LIMIT 4;"
	@echo ""
	@echo "Transformed data in target:"
	@docker compose exec -T postgres psql -U analytics -d analytics_db -c "SELECT * FROM target_table ORDER BY id DESC LIMIT 4;"
	@echo ""

example-airflow:
	@echo "=== Example 1-2: Airflow DAG ==="
	@echo "Airflow is running at http://localhost:8080"
	@echo "Login: admin / admin"
	@echo ""
	@echo "DAG file:"
	@cat "examples/Example 1-2. An Airflow DAG.py"
	@echo ""
	@echo "To see the DAG in action, visit the Airflow UI"
	@echo ""

example-dbt:
	@echo "=== Example 1-3: dbt Model ==="
	@echo "Running dbt model..."
	@docker compose exec -T dbt dbt run --project-dir /usr/app/dbt --profiles-dir /usr/app
	@echo ""
	@echo "Verifying results:"
	@docker compose exec -T postgres psql -U analytics -d analytics_db -c "SELECT * FROM total_revenue;"
	@echo ""