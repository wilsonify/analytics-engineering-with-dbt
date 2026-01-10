-- Example 2-24: Complex query 1
-- This demonstrates a complex analytical query with joins, aggregations, and filtering

DROP TABLE IF EXISTS demo_table2 CASCADE;
DROP TABLE IF EXISTS demo_table1 CASCADE;

-- Create demo tables
CREATE TABLE demo_table1 (
    id INT PRIMARY KEY,
    column1 VARCHAR(50),
    column2 VARCHAR(50),
    column3 DECIMAL(10,2),
    column4 VARCHAR(50)
);

CREATE TABLE demo_table2 (
    id INT PRIMARY KEY,
    additional_info VARCHAR(100)
);

-- Insert sample data
INSERT INTO demo_table1 (id, column1, column2, column3, column4) VALUES
    (1, 'Product A', 'Region 1', 500, 'some_value'),
    (2, 'Product A', 'Region 1', 600, 'some_value'),
    (3, 'Product B', 'Region 2', 1200, 'some_value'),
    (4, 'Product B', 'Region 2', 800, 'other_value'),
    (5, 'Product C', 'Region 1', 1500, 'some_value');

INSERT INTO demo_table2 (id, additional_info) VALUES
    (1, 'Info A'),
    (2, 'Info B'),
    (3, 'Info C');

-- Complex query with join, aggregation, and filtering
SELECT 
    t1.column1, 
    t1.column2, 
    SUM(t1.column3) AS total_sum 
FROM demo_table1 t1
INNER JOIN demo_table2 t2 ON t1.id = t2.id
WHERE t1.column4 = 'some_value'
GROUP BY t1.column1, t1.column2
HAVING SUM(t1.column3) > 1000
ORDER BY total_sum DESC;