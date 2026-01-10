-- Example 2-18: Mart model
-- This demonstrates creating a final mart/analytics table for reporting
-- Note: In dbt, config options would be in {{ config() }} block

DROP TABLE IF EXISTS mart_book_authors CASCADE;

-- Create mart table with aggregated metrics
CREATE TABLE mart_book_authors AS
WITH book_counts AS (
    SELECT
        author_id,
        COUNT(*) AS total_books
    FROM int_book_authors
    GROUP BY author_id
)
SELECT
    bc.author_id,
    a.author_name,
    bc.total_books
FROM book_counts bc
JOIN stg_authors a ON bc.author_id = a.author_id
ORDER BY bc.author_id;

SELECT 'Mart model created' AS status;
SELECT * FROM mart_book_authors;