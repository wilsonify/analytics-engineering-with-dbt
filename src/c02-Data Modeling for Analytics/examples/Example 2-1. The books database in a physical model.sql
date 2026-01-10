-- Example 2-1: The books database in a physical model
-- This demonstrates a complete physical data model with proper relationships

-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS publishes CASCADE;
DROP TABLE IF EXISTS books_physical CASCADE;
DROP TABLE IF EXISTS authors_physical CASCADE;
DROP TABLE IF EXISTS category CASCADE;

-- Create category table
CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255)
);

-- Create authors table
CREATE TABLE authors_physical (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(255),
    date_birth TIMESTAMP
);

-- Create books table with foreign key to category
CREATE TABLE books_physical (
    book_id INT PRIMARY KEY,
    isbn VARCHAR(13),
    title VARCHAR(255),
    summary VARCHAR(255),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- Create publishes table (junction table)
CREATE TABLE publishes (
    book_id INT,
    author_id INT,
    publish_date DATE,
    planned_publish_date DATE,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books_physical(book_id),
    FOREIGN KEY (author_id) REFERENCES authors_physical(author_id)
);

-- Insert sample data
INSERT INTO category (category_id, category_name) VALUES
    (1, 'Technology'),
    (2, 'Fiction'),
    (3, 'Science');

INSERT INTO authors_physical (author_id, author_name, date_birth) VALUES
    (1, 'John Smith', '1975-03-15'),
    (2, 'Jane Doe', '1982-07-22');

INSERT INTO books_physical (book_id, isbn, title, summary, category_id) VALUES
    (1, '9781234567890', 'Data Modeling Essentials', 'A comprehensive guide to data modeling', 1),
    (2, '9780987654321', 'Analytics Engineering', 'Modern analytics engineering practices', 1);

INSERT INTO publishes (book_id, author_id, publish_date, planned_publish_date) VALUES
    (1, 1, '2020-01-15', '2020-01-01'),
    (2, 2, '2021-06-10', '2021-06-01');

-- Verify the data
SELECT 'Physical Model Created Successfully' AS status;
SELECT * FROM category;
SELECT * FROM authors_physical LIMIT 3;
SELECT * FROM books_physical LIMIT 3;
