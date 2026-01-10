-- Example 2-5: books table in 3NF (Third Normal Form)
-- This demonstrates Third Normal Form normalization

DROP TABLE IF EXISTS book_details_3nf CASCADE;
DROP TABLE IF EXISTS books_3nf CASCADE;
DROP TABLE IF EXISTS authors_3nf CASCADE;
DROP TABLE IF EXISTS genres CASCADE;

-- Table Authors
CREATE TABLE authors_3nf (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100)
);

-- Table Genres (extracted to eliminate transitive dependency)
CREATE TABLE genres (
    genre_id INT PRIMARY KEY,
    genre_name VARCHAR(50)
);

-- Table Books
CREATE TABLE books_3nf (
    book_id INT PRIMARY KEY,
    title VARCHAR(100)
);

-- Table book details (with foreign keys to normalized tables)
CREATE TABLE book_details_3nf (
    book_id INT PRIMARY KEY,
    author_id INT,
    genre_id INT,
    publication_year INT,
    FOREIGN KEY (book_id) REFERENCES books_3nf(book_id),
    FOREIGN KEY (author_id) REFERENCES authors_3nf(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- Insert sample data
INSERT INTO authors_3nf (author_id, author_name) VALUES
    (1, 'John Smith'),
    (2, 'Jane Doe'),
    (3, 'Alice Brown');

INSERT INTO genres (genre_id, genre_name) VALUES
    (1, 'Technology'),
    (2, 'Fiction'),
    (3, 'Science');

INSERT INTO books_3nf (book_id, title) VALUES
    (1, 'Data Modeling Essentials'),
    (2, 'Advanced SQL'),
    (3, 'Analytics Engineering'),
    (4, 'Database Design');

INSERT INTO book_details_3nf (book_id, author_id, genre_id, publication_year) VALUES
    (1, 1, 1, 2020),
    (2, 1, 1, 2021),
    (3, 2, 1, 2021),
    (4, 3, 1, 2022);

SELECT '3NF tables created' AS status;
SELECT b.*, bd.publication_year, a.author_name, g.genre_name
FROM books_3nf b 
JOIN book_details_3nf bd ON b.book_id = bd.book_id
JOIN authors_3nf a ON bd.author_id = a.author_id
JOIN genres g ON bd.genre_id = g.genre_id;