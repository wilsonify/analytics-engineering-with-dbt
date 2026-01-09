# Example 6-5: ETL Pipeline - Extraction Function
# Simulate the extraction step in an ETL job

def extract_table_from_mysql(table_name, my_sql_connection):
    # Extract data from mysql table
    extraction_query = 'select * from ' + table_name
    df_table_data = pd.read_sql(extraction_query, my_sql_connection)
    return df_table_data
