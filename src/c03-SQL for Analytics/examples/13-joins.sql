-- Example 3-28: INNER JOIN
SELECT 
    b.book_title,
    b.publication_year,
    a.first_name,
    a.last_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id;

-- Example 3-29: LEFT JOIN
SELECT 
    b.book_title,
    a.first_name,
    a.last_name
FROM books b
LEFT JOIN authors a ON b.author_id = a.author_id;

-- Example 3-30: RIGHT JOIN
SELECT 
    b.book_title,
    a.first_name,
    a.last_name
FROM books b
RIGHT JOIN authors a ON b.author_id = a.author_id;

-- Example 3-31: FULL OUTER JOIN
SELECT 
    b.book_title,
    a.first_name,
    a.last_name
FROM books b
FULL OUTER JOIN authors a ON b.author_id = a.author_id;

-- Example 3-32: CROSS JOIN
SELECT 
    b.book_title,
    a.first_name
FROM books b
CROSS JOIN authors a;
