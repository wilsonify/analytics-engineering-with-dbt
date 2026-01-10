-- Example 2-16: Staging model
-- This demonstrates a staging layer that cleanses and standardizes raw data

DROP TABLE IF EXISTS stg_books CASCADE;
DROP TABLE IF EXISTS raw_books CASCADE;

-- Create raw source table
CREATE TABLE raw_books (
    book_id INT,
    title VARCHAR(100),
    author VARCHAR(100),
    publication_year INT,
    genre VARCHAR(50)
);

-- Insert raw data (with some quality issues to demonstrate staging)
INSERT INTO raw_books (book_id, title, author, publication_year, genre) VALUES
    (1, 'Data Modeling Essentials', 'John Smith', 2020, 'Technology'),
    (2, 'Advanced SQL', 'John Smith', 2021, 'Technology'),
    (3, 'Analytics Engineering', 'Jane Doe', 2021, 'Technology'),
    (4, 'Database Design', 'Alice Brown', 2022, 'Technology');

-- Create staging table that cleans and standardizes the data
CREATE TABLE stg_books AS
SELECT
    book_id,
    TRIM(title) AS title,
    TRIM(author) AS author,
    publication_year,
    UPPER(genre) AS genre
FROM
    raw_books
WHERE book_id IS NOT NULL;

SELECT 'Staging model created' AS status;
SELECT * FROM stg_books;