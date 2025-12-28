CREATE PROCEDURE etl_example AS
BEGIN
    -- Extract
    SELECT * INTO #temp_table FROM source_table;
    
    -- Transform
    UPDATE #temp_table
    SET column1 = UPPER(column1),
        column2 = column2 * 2;
    
    -- Load
    INSERT INTO target_table
    SELECT * FROM #temp_table;
END
