-- Example 3-23: GROUP BY with Aggregate Functions
SELECT author_id, COUNT(*) AS book_count
FROM books
GROUP BY author_id;

-- Example 3-24: Common Aggregate Functions
SELECT 
    COUNT(*) AS total_books,
    AVG(price) AS avg_price,
    SUM(price) AS total_price,
    MIN(publication_year) AS earliest,
    MAX(publication_year) AS latest
FROM books;

-- Example 3-25: HAVING Clause (filter groups)
SELECT author_id, COUNT(*) AS book_count
FROM books
GROUP BY author_id
HAVING COUNT(*) > 2;
