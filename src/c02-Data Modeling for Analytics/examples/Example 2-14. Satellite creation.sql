-- Example 2-14: Satellite creation
-- This demonstrates creating a Satellite table in Data Vault 2.0

DROP TABLE IF EXISTS sat_books CASCADE;

CREATE TABLE sat_books (
    book_key INT,
    load_date TIMESTAMP,
    author VARCHAR(100),
    publication_year INT,
    genre VARCHAR(50),
    record_source VARCHAR(50) DEFAULT 'books_source',
    PRIMARY KEY (book_key, load_date),
    FOREIGN KEY (book_key) REFERENCES hub_books(book_key)
);

-- Insert sample satellite data
INSERT INTO sat_books (book_key, load_date, author, publication_year, genre) VALUES
    (1, '2020-01-15 10:00:00', 'John Smith', 2020, 'Technology'),
    (2, '2021-02-20 11:00:00', 'John Smith', 2021, 'Technology'),
    (3, '2021-06-10 12:00:00', 'Jane Doe', 2021, 'Technology'),
    (4, '2022-03-05 13:00:00', 'Alice Brown', 2022, 'Technology');

SELECT 'Satellite table created' AS status;
SELECT h.title, s.*
FROM sat_books s
JOIN hub_books h ON s.book_key = h.book_key;