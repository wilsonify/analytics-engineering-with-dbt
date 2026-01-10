-- Example 2-17: Intermediate model
-- This demonstrates combining multiple staging models into an intermediate layer

DROP TABLE IF EXISTS int_book_authors CASCADE;
DROP TABLE IF EXISTS stg_authors CASCADE;
DROP TABLE IF EXISTS raw_authors CASCADE;

-- Create raw authors table
CREATE TABLE raw_authors (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100),
    birth_year INT
);

INSERT INTO raw_authors (author_id, author_name, birth_year) VALUES
    (1, 'John Smith', 1975),
    (2, 'Jane Doe', 1982),
    (3, 'Alice Brown', 1990);

-- Create staging authors
CREATE TABLE stg_authors AS
SELECT
    author_id,
    TRIM(author_name) AS author_name,
    birth_year
FROM raw_authors;

-- Add author_id to stg_books if not exists
ALTER TABLE stg_books ADD COLUMN IF NOT EXISTS author_id INT;
UPDATE stg_books SET author_id = 1 WHERE book_id IN (1, 2);
UPDATE stg_books SET author_id = 2 WHERE book_id = 3;
UPDATE stg_books SET author_id = 3 WHERE book_id = 4;

-- Create intermediate model combining books and authors
CREATE TABLE int_book_authors AS
WITH
books AS (
    SELECT * FROM stg_books
),
authors AS (
    SELECT * FROM stg_authors
)
-- Combine the relevant information
SELECT
    b.book_id,
    b.title,
    a.author_id,
    a.author_name
FROM
    books b
JOIN
    authors a ON b.author_id = a.author_id;

SELECT 'Intermediate model created' AS status;
SELECT * FROM int_book_authors;
