-- Initialize database for examples

-- Create Airflow database
CREATE DATABASE airflow_db;

-- Create sample source table for ETL example
CREATE TABLE IF NOT EXISTS source_table (
    id SERIAL PRIMARY KEY,
    column1 VARCHAR(100),
    column2 INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create target table for ETL example
CREATE TABLE IF NOT EXISTS target_table (
    id SERIAL PRIMARY KEY,
    column1 VARCHAR(100),
    column2 INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO source_table (column1, column2) VALUES
    ('hello', 10),
    ('world', 20),
    ('analytics', 30),
    ('engineering', 40);

-- Create tables for dbt example
CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    revenue DECIMAL(10,2),
    order_date DATE
);

INSERT INTO orders (customer_id, revenue, order_date) VALUES
    (1, 100.50, '2024-01-01'),
    (2, 250.75, '2024-01-02'),
    (1, 150.00, '2024-01-03'),
    (3, 300.25, '2024-01-04');

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO analytics;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO analytics;
