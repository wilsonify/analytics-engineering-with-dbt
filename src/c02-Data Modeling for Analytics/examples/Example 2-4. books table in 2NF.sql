-- Example 2-4: books table in 2NF (Second Normal Form)
-- This demonstrates Second Normal Form normalization

DROP TABLE IF EXISTS book_details_2nf CASCADE;
DROP TABLE IF EXISTS books_2nf CASCADE;
DROP TABLE IF EXISTS authors_2nf CASCADE;

-- Table Authors
CREATE TABLE authors_2nf (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100)
);

-- Table Books (only key and title)
CREATE TABLE books_2nf (
    book_id INT PRIMARY KEY,
    title VARCHAR(100)
);

-- Table book details (non-key attributes)
CREATE TABLE book_details_2nf (
    book_id INT PRIMARY KEY,
    author_id INT,
    genre VARCHAR(50),
    publication_year INT,
    FOREIGN KEY (book_id) REFERENCES books_2nf(book_id),
    FOREIGN KEY (author_id) REFERENCES authors_2nf(author_id)
);

-- Insert sample data
INSERT INTO authors_2nf (author_id, author_name) VALUES
    (1, 'John Smith'),
    (2, 'Jane Doe'),
    (3, 'Alice Brown');

INSERT INTO books_2nf (book_id, title) VALUES
    (1, 'Data Modeling Essentials'),
    (2, 'Advanced SQL'),
    (3, 'Analytics Engineering'),
    (4, 'Database Design');

INSERT INTO book_details_2nf (book_id, author_id, genre, publication_year) VALUES
    (1, 1, 'Technology', 2020),
    (2, 1, 'Technology', 2021),
    (3, 2, 'Technology', 2021),
    (4, 3, 'Technology', 2022);

SELECT '2NF tables created' AS status;
SELECT b.*, bd.*, a.author_name 
FROM books_2nf b 
JOIN book_details_2nf bd ON b.book_id = bd.book_id
JOIN authors_2nf a ON bd.author_id = a.author_id;