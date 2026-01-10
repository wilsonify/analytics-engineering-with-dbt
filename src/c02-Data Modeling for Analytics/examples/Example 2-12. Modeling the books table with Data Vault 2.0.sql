-- Example 2-12: Modeling the books table with Data Vault 2.0
-- This shows the source table that will be modeled using Data Vault

DROP TABLE IF EXISTS books_source CASCADE;

CREATE TABLE books_source (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(100),
    publication_year INT,
    genre VARCHAR(50)
);

-- Insert sample source data
INSERT INTO books_source (book_id, title, author, publication_year, genre) VALUES
    (1, 'Data Modeling Essentials', 'John Smith', 2020, 'Technology'),
    (2, 'Advanced SQL', 'John Smith', 2021, 'Technology'),
    (3, 'Analytics Engineering', 'Jane Doe', 2021, 'Technology'),
    (4, 'Database Design', 'Alice Brown', 2022, 'Technology');

SELECT 'Data Vault source table created' AS status;
SELECT * FROM books_source;
