-- Example 3-35: DELETE Statement
DELETE FROM books WHERE book_id = 3;

-- Example 3-36: DELETE with Condition
DELETE FROM books WHERE publication_year < 1980;

-- Delete all rows (use with caution)
DELETE FROM books;
