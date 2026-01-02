-- Example 3-43: ROW_NUMBER
SELECT 
    book_id,
    book_title,
    publication_year,
    ROW_NUMBER() OVER (ORDER BY publication_year) AS row_num
FROM books;

-- Example 3-44: RANK and DENSE_RANK
SELECT 
    book_id,
    book_title,
    publication_year,
    RANK() OVER (ORDER BY publication_year) AS rank,
    DENSE_RANK() OVER (ORDER BY publication_year) AS dense_rank
FROM books;

-- Example 3-45: NTILE (buckets)
SELECT 
    book_id,
    book_title,
    publication_year,
    NTILE(3) OVER (ORDER BY publication_year) AS bucket
FROM books;

-- Example 3-46: LAG and LEAD
SELECT 
    book_id,
    book_title,
    publication_year,
    LAG(publication_year) OVER (ORDER BY publication_year) AS prev_year,
    LEAD(publication_year) OVER (ORDER BY publication_year) AS next_year
FROM books;

-- Example 3-47: Window Aggregate Functions
SELECT 
    book_id,
    book_title,
    price,
    AVG(price) OVER () AS avg_price,
    SUM(price) OVER (ORDER BY publication_year) AS running_total
FROM books;

-- Example 3-48: PARTITION BY
SELECT 
    book_id,
    book_title,
    author_id,
    price,
    AVG(price) OVER (PARTITION BY author_id) AS author_avg_price
FROM books;
