-- Example 3-37: CREATE VIEW
CREATE VIEW recent_books AS
SELECT book_id, book_title, publication_year, price
FROM books
WHERE publication_year >= 2000;

-- Example 3-38: Query a View
SELECT * FROM recent_books;

-- Example 3-39: DROP VIEW
DROP VIEW recent_books;
