# Machine Learning with SQL (dask-sql)

"""
Example: Training ML Models using SQL with dask-sql
"""
import dask.dataframe as dd
from dask_sql import Context

# Create dask-sql context
c = Context()

# Load the Iris dataset
df = dd.read_csv('https://datahub.io/machine-learning/iris/r/iris.csv')
c.create_table("iris", df)

# Test data access
c.sql("SELECT * FROM iris")

# Create a KMeans clustering model
c.sql("""
    CREATE OR REPLACE MODEL clustering WITH (
        model_class = 'sklearn.cluster.KMeans',
        wrap_predict = True,
        n_clusters = 3
    ) AS (
        SELECT sepallength, sepalwidth, petallength, petalwidth
        FROM iris
    )
""")

# Show available models
c.sql("SHOW MODELS")

# View model hyperparameters
c.sql("DESCRIBE MODEL clustering")

# Make predictions
c.sql("""
    SELECT * FROM PREDICT (
        MODEL clustering,
        SELECT sepallength, sepalwidth, petallength, petalwidth 
        FROM iris
        LIMIT 100
    )
""")

# Hyperparameter tuning with GridSearchCV
c.sql("""
    CREATE EXPERIMENT first_experiment WITH (
        model_class = 'sklearn.cluster.KMeans',
        experiment_class = 'GridSearchCV',
        tune_parameters = (n_clusters = ARRAY [2, 3, 4]),
        experiment_kwargs = (n_jobs = -1),
        target_column = 'target'
    ) AS (
        SELECT sepallength, sepalwidth, petallength, petalwidth, class AS target
        FROM iris
        LIMIT 100
    )
""")

# Export model as pickle file
c.sql("""
    EXPORT MODEL clustering WITH (
        format = 'pickle',
        location = './clustering.pkl'
    )
""")
