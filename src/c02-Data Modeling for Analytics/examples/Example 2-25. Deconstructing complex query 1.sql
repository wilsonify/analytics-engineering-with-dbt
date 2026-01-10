-- Example 2-25: Deconstructing complex query 1
-- This demonstrates breaking down a complex query using CTEs for better optimization and readability

-- Deconstructing the complex query from Example 2-24 using CTEs

-- CTE 1: Joining required data
WITH join_query AS (
    SELECT 
        t1.column1, 
        t1.column2, 
        t1.column3,
        t1.column4
    FROM demo_table1 t1
    INNER JOIN demo_table2 t2 ON t1.id = t2.id
),

-- CTE 2: Filtering rows
filter_query AS (
    SELECT 
        column1, 
        column2, 
        column3
    FROM join_query
    WHERE column4 = 'some_value'
),

-- CTE 3: Aggregating and filtering results
aggregate_query AS (
    SELECT 
        column1, 
        column2, 
        SUM(column3) AS total_sum 
    FROM filter_query
    GROUP BY column1, column2
    HAVING SUM(column3) > 1000
)

-- Final query to retrieve the optimized results
SELECT *
FROM aggregate_query
ORDER BY total_sum DESC;