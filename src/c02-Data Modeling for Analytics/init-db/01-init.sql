-- Initialize database for Chapter 2 examples

-- Create Airflow database
CREATE DATABASE airflow_db;

-- Create books table for data modeling examples
CREATE TABLE IF NOT EXISTS books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255),
    publisher VARCHAR(255),
    publication_year INTEGER,
    isbn VARCHAR(20),
    genre VARCHAR(100),
    price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data for books
INSERT INTO books (title, author, publisher, publication_year, isbn, genre, price) VALUES
    ('Data Modeling Essentials', 'John Smith', 'Tech Press', 2020, '978-1234567890', 'Technology', 49.99),
    ('Analytics Engineering', 'Jane Doe', 'Data Publishers', 2021, '978-0987654321', 'Technology', 59.99),
    ('SQL Fundamentals', 'Bob Johnson', 'Tech Press', 2019, '978-1122334455', 'Technology', 39.99),
    ('Database Design', 'Alice Brown', 'Code Books', 2022, '978-5566778899', 'Technology', 54.99);

-- Create orders table for dbt example
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
