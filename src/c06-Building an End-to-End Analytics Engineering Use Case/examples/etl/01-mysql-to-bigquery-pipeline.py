# Example 6-4: ETL Pipeline - Main Orchestrator
# Extract data from MySQL and load into BigQuery

import mysql.connector as connection
import pandas as pd

def data_pipeline_mysql_to_bq(**kwargs):
    mysql_host = kwargs.get('mysql_host')
    mysql_database = kwargs.get('mysql_database')
    mysql_user = kwargs.get('mysql_user')
    mysql_password = kwargs.get('mysql_password')
    bq_project_id = kwargs.get('bq_project_id')
    dataset = kwargs.get('dataset')
    
    try:
        mydb = connection.connect(
            host=mysql_host,
            database=mysql_database,
            user=mysql_user,
            passwd=mysql_password,
            use_pure=True
        )
        
        all_tables = "Select table_name from information_schema.tables where table_schema = '{}'".format(mysql_database)
        df_tables = pd.read_sql(all_tables, mydb, parse_dates={'Date': {'format': '%Y-%m-%d'}})
        
        for table in df_tables.TABLE_NAME:
            table_name = table
            
            # Extract table data from MySQL
            df_table_data = extract_table_from_mysql(table_name, mydb)
            
            # Transform table data from MySQL
            df_table_data = transform_data_from_table(df_table_data)
            
            # Load data to BigQuery
            load_data_into_bigquery(bq_project_id, dataset, table_name, df_table_data)
            
            # Show confirmation message
            print("Ingested table {}".format(table_name))
        
        mydb.close()  # close the connection
        
    except Exception as e:
        mydb.close()
        print(str(e))
