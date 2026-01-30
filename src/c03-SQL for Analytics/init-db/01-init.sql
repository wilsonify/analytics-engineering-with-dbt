-- Initialize database for SQL analytics examples

-- Authors table
CREATE TABLE IF NOT EXISTS authors (
    author_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_year INT
);

-- Books table with foreign key reference
CREATE TABLE IF NOT EXISTS books (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(255),
    publication_year INT,
    price DECIMAL(5, 2),
    author_id INT,
    CONSTRAINT fk_books_author_id FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- Orders table for dbt example
CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    revenue DECIMAL(10,2),
    order_date DATE
);

-- Seed data (idempotent)
INSERT INTO authors (author_id, first_name, last_name, birth_year)
VALUES (1, 'Stephen', 'King', 1947)
ON CONFLICT (author_id) DO NOTHING;

INSERT INTO books (book_id, book_title, publication_year, price, author_id)
VALUES
    (1, 'The Shining', 1977, 19.99, 1),
    (2, 'It', 1986, 24.99, 1),
    (3, 'Carrie', 1974, 14.99, 1)
ON CONFLICT (book_id) DO NOTHING;

INSERT INTO orders (customer_id, revenue, order_date)
VALUES
    (1, 100.50, '2024-01-01'),
    (2, 250.75, '2024-01-02'),
    (1, 150.00, '2024-01-03'),
    (3, 300.25, '2024-01-04')
ON CONFLICT DO NOTHING;
