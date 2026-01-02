# DuckDB Examples

"""
Example: Basic DuckDB Usage with pandas
"""
import duckdb
import pandas as pd

# Create a pandas DataFrame
df = pd.DataFrame({'a': [1, 2, 3]})

# Query with DuckDB
result = duckdb.query("SELECT SUM(a) FROM df").to_df()
print(result)


"""
Example: Register DataFrame as Table
"""
import duckdb
import pandas as pd

# Sample O'Reilly books data
data = [
    {'Title': 'Python for Data Analysis', 'Author': 'Wes McKinney', 
     'Publisher': "O'Reilly", 'Price': 39.99, 'UnitsSold': 1000},
    {'Title': 'Hands-On Machine Learning', 'Author': 'Aurélien Géron', 
     'Publisher': "O'Reilly", 'Price': 49.99, 'UnitsSold': 800},
    {'Title': 'Deep Learning', 'Author': 'Ian Goodfellow', 
     'Publisher': "O'Reilly", 'Price': 59.99, 'UnitsSold': 1200},
    {'Title': 'Data Science from Scratch', 'Author': 'Joel Grus', 
     'Publisher': "O'Reilly", 'Price': 29.99, 'UnitsSold': 600}
]

df = pd.DataFrame(data)
con = duckdb.connect()
con.register('sales', df)

# Calculate total revenue
query = """
    SELECT SUM(Price * UnitsSold) AS total_revenue
    FROM sales
    WHERE Publisher = 'O''Reilly'
"""
result = con.execute(query).df()
print(result)


"""
Example: FastAPI Integration with DuckDB
"""
from fastapi import FastAPI
import duckdb

app = FastAPI()

@app.get("/top_books")
def get_top_books():
    conn = duckdb.connect()
    query = '''
        SELECT Title, UnitsSold
        FROM sales
        WHERE Publisher = 'O''Reilly'
        ORDER BY UnitsSold DESC
        LIMIT 5
    '''
    result = conn.execute(query)
    books = [{"title": row[0], "units_sold": row[1]} for row in result]
    return {"top_books": books}
