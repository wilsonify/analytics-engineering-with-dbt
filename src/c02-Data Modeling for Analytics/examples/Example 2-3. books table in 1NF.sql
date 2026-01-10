-- Example 2-3: books table in 1NF (First Normal Form)
-- This demonstrates First Normal Form normalization

DROP TABLE IF EXISTS books_1nf CASCADE;
DROP TABLE IF EXISTS authors_1nf CASCADE;

-- Table Authors
CREATE TABLE authors_1nf (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100)
);

-- Table Books in 1NF
CREATE TABLE books_1nf (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    publication_year INT,
    genre VARCHAR(50),
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES authors_1nf(author_id)
);

-- Insert sample data
INSERT INTO authors_1nf (author_id, author_name) VALUES
    (1, 'John Smith'),
    (2, 'Jane Doe'),
    (3, 'Alice Brown');

INSERT INTO books_1nf (book_id, title, publication_year, genre, author_id) VALUES
    (1, 'Data Modeling Essentials', 2020, 'Technology', 1),
    (2, 'Advanced SQL', 2021, 'Technology', 1),
    (3, 'Analytics Engineering', 2021, 'Technology', 2),
    (4, 'Database Design', 2022, 'Technology', 3);

SELECT '1NF tables created' AS status;
SELECT b.*, a.author_name 
FROM books_1nf b 
JOIN authors_1nf a ON b.author_id = a.author_id;