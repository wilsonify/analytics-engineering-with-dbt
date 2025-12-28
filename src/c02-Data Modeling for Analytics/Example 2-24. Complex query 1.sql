SELECT column1, column2, SUM(column3) AS total_sum FROM table1

INNER JOIN table2 ON table1.id = table2.id

WHERE column4 = 'some_value'

GROUP BY column1, column2

HAVING total_sum > 1000