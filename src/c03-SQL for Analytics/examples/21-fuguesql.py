# FugueSQL Examples

"""
Example: FugueSQL with Multiple Engines
"""
import pandas as pd
import fugue.api as fa

# Prepare sample data
data = [
    {'Title': 'Python for Data Analysis', 'Author': 'Wes McKinney',
     'Publisher': "OReilly", 'Price': 39.99, 'UnitsSold': 1000},
    {'Title': 'Hands-On Machine Learning', 'Author': 'Aurélien Géron',
     'Publisher': "OReilly", 'Price': 49.99, 'UnitsSold': 800},
    {'Title': 'Deep Learning', 'Author': 'Ian Goodfellow',
     'Publisher': "OReilly", 'Price': 59.99, 'UnitsSold': 1200},
    {'Title': 'Data Science from Scratch', 'Author': 'Joel Grus',
     'Publisher': "OReilly", 'Price': 29.99, 'UnitsSold': 600}
]

df = pd.DataFrame(data)
df.to_parquet("/tmp/df.parquet")

# FugueSQL with pandas engine
query = """
    LOAD "/tmp/df.parquet"
    SELECT Author, COUNT(Title) AS NbBooks
    GROUP BY Author
    PRINT
"""
pandas_df = fa.fugue_sql(query, engine="pandas")

# FugueSQL with Spark engine
spark_df = fa.fugue_sql(query, engine="spark")

# FugueSQL with DuckDB engine
import duckdb

query_duckdb = """
    df = LOAD "/tmp/df.parquet"
    res = SELECT * FROM df WHERE Author = 'Wes McKinney'
    SAVE res OVERWRITE "/tmp/df2.parquet"
"""
fa.fugue_sql(query_duckdb, engine="duckdb")

with duckdb.connect() as conn:
    df2 = conn.execute("SELECT * FROM '/tmp/df2.parquet'").fetchdf()
    print(df2.head())
