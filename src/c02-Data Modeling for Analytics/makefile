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
	src/c02-Data Modeling for Analytics/examples/Example 2-1. The books database in a physical model.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-10. Star schema location dimension.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-10. Star schema location dimension.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-11. Snowflake schema location dimension.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-11. Snowflake schema location dimension.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-12. Modeling the books table with Data Vault 2.0.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-12. Modeling the books table with Data Vault 2.0.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-13. Hub creation.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-13. Hub creation.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-14. Satellite creation.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-14. Satellite creation.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-15. Referencing model.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-15. Referencing model.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-16. Staging model.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-16. Staging model.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-17. Intermediate model.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-17. Intermediate model.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-18. Mart model.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-18. Mart model.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-19. Singular test example in dbt.yaml 
	src/c02-Data Modeling for Analytics/examples/Example 2-19. Singular test example in dbt.yaml 
	src/c02-Data Modeling for Analytics/examples/Example 2-2. books table to be normalized.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-20. Generic test example in dbt.yaml 
	src/c02-Data Modeling for Analytics/examples/Example 2-20. Generic test example in dbt.yaml 
	src/c02-Data Modeling for Analytics/examples/Example 2-22. Documentation.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-22. Documentation.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-23. Running documentation generation.sh 
	src/c02-Data Modeling for Analytics/examples/Example 2-24. Complex query 1.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-25. Deconstructing complex query 1.sql
	src/c02-Data Modeling for Analytics/examples/Example 2-3. books table in 1NF.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-4. books table in 2NF.sql 
	src/c02-Data Modeling for Analytics/examples/Example 2-5. books table in 3NF.sql 
	@echo "✓ All examples completed!"
