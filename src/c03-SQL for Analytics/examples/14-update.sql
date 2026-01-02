-- Example 3-33: UPDATE Statement
UPDATE books
SET price = 29.99
WHERE book_id = 1;

-- Example 3-34: UPDATE Multiple Columns
UPDATE books
SET price = 34.99, publication_year = 1978
WHERE book_title = 'The Shining';
