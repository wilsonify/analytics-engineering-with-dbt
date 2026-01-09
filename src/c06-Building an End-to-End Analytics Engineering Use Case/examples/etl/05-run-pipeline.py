# Example 6-8: ETL Pipeline - Execution
# Call main function with configuration

# Call main function
kwargs = {
    # BigQuery connection details
    'bq_project_id': '<ADD_YOUR_BQ_PROJECT_ID>',
    'dataset': 'omnichannel_raw',
    # MySQL connection details
    'mysql_host': '<ADD_YOUR_HOST_INFO>',
    'mysql_user': '<ADD_YOUR_MYSQL_USER>',
    'mysql_password': '<ADD_YOUR_MYSQL_PASSWORD>',
    'mysql_database': 'OMNI_MANAGEMENT'
}

data_pipeline_mysql_to_bq(**kwargs)
