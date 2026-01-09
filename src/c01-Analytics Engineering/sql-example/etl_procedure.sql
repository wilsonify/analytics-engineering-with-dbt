-- ETL Procedure Example (PostgreSQL version)
-- This demonstrates Extract, Transform, Load pattern

BEGIN;

-- Extract: Create temporary table with source data
CREATE TEMP TABLE temp_table AS
SELECT * FROM source_table;

-- Transform: Apply transformations
UPDATE temp_table
SET column1 = UPPER(column1),
    column2 = column2 * 2;

-- Load: Insert into target table
INSERT INTO target_table (column1, column2)
SELECT column1, column2 FROM temp_table;

COMMIT;

-- Verify results
SELECT 'Source data:' as step;
SELECT * FROM source_table;

SELECT 'Target data (after ETL):' as step;
SELECT * FROM target_table;
