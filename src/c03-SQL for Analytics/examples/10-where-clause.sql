-- Example 3-17: WHERE Clause - Comparison Operators
SELECT * FROM books WHERE publication_year > 2000;
SELECT * FROM books WHERE price <= 25.00;
SELECT * FROM books WHERE book_title != 'The Shining';

-- Example 3-18: WHERE Clause - Logical Operators (AND, OR, NOT)
SELECT * FROM books WHERE publication_year > 2000 AND price < 30;
SELECT * FROM books WHERE publication_year < 1980 OR price > 50;
SELECT * FROM books WHERE NOT publication_year = 1986;

-- Example 3-19: WHERE Clause - BETWEEN
SELECT * FROM books WHERE publication_year BETWEEN 1980 AND 2000;

-- Example 3-20: WHERE Clause - IN
SELECT * FROM books WHERE publication_year IN (1974, 1977, 1986);

-- Example 3-21: WHERE Clause - LIKE
SELECT * FROM books WHERE book_title LIKE 'The%';
SELECT * FROM books WHERE book_title LIKE '%King%';

-- Example 3-22: WHERE Clause - IS NULL / IS NOT NULL
SELECT * FROM books WHERE author_id IS NOT NULL;
