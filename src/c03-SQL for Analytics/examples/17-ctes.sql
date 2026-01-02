-- Example 3-40: Basic CTE
WITH author_book_count AS (
    SELECT author_id, COUNT(*) AS book_count
    FROM books
    GROUP BY author_id
)
SELECT 
    a.first_name,
    a.last_name,
    abc.book_count
FROM authors a
JOIN author_book_count abc ON a.author_id = abc.author_id;

-- Example 3-41: Multiple CTEs
WITH 
    recent_books AS (
        SELECT * FROM books WHERE publication_year >= 2000
    ),
    prolific_authors AS (
        SELECT author_id FROM books GROUP BY author_id HAVING COUNT(*) > 3
    )
SELECT rb.book_title, rb.publication_year
FROM recent_books rb
WHERE rb.author_id IN (SELECT author_id FROM prolific_authors);

-- Example 3-42: Recursive CTE (hierarchical data)
WITH RECURSIVE book_series AS (
    -- Base case
    SELECT book_id, book_title, 1 AS level
    FROM books
    WHERE book_id = 1
    
    UNION ALL
    
    -- Recursive case
    SELECT b.book_id, b.book_title, bs.level + 1
    FROM books b
    JOIN book_series bs ON b.author_id = bs.book_id
    WHERE bs.level < 3
)
SELECT * FROM book_series;
