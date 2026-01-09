# Example 6-7: ETL Pipeline - Load Function
# Simulate the load step in an ETL job

def load_data_into_bigquery(bq_project_id, dataset, table_name, df_table_data):
    import pandas_gbq as pdbq
    
    full_table_name_bg = "{}.{}".format(dataset, table_name)
    pdbq.to_gbq(df_table_data, full_table_name_bg, project_id=bq_project_id, if_exists='replace')
