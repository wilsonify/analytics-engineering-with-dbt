-- Deconstructing a complex query using CTEs for optimization

-- CTE 1: Joining required data

WITH join_query AS (

SELECT table1.column1, table1.column2, table2.column3

FROM table1

INNER JOIN table2 ON table1.id = table2.id

)

-- CTE 2: Filtering rows

, filter_query AS (

SELECT column1, column2, column3

FROM join_query

WHERE column4 = 'some_value'

)

-- CTE 3: Aggregating and filtering results

, aggregate_query AS (

SELECT column1, column2, SUM(column3) AS total_sum FROM filter_query



GROUP BY column1, column2

HAVING total_sum > 1000

)

-- Final query to retrieve the optimized results, and this will be our model SELECT *

FROM aggregate_query;