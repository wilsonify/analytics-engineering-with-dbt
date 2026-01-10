-- Example 2-2: books table to be normalized
-- This shows a denormalized table before normalization

DROP TABLE IF EXISTS books_unnormalized CASCADE;

CREATE TABLE books_unnormalized (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(100),
    publication_year INT,
    genre VARCHAR(50)
);

-- Insert sample data showing denormalization issues
INSERT INTO books_unnormalized (book_id, title, author, publication_year, genre) VALUES
    (1, 'Data Modeling Essentials', 'John Smith', 2020, 'Technology'),
    (2, 'Advanced SQL', 'John Smith', 2021, 'Technology'),
    (3, 'Analytics Engineering', 'Jane Doe', 2021, 'Technology'),
    (4, 'Database Design', 'Alice Brown', 2022, 'Technology');

SELECT 'Unnormalized books table created' AS status;
SELECT * FROM books_unnormalized;