# Polars Examples

"""
Example: Basic Polars DataFrame
"""
import polars as pl

df = pl.DataFrame({
    'Title': ['Python Crash Course', 'Hands-On Machine Learning',
              'Data Science for Business', 'Learning SQL',
              'JavaScript: The Good Parts', 'Clean Code'],
    'UnitsSold': [250, 180, 320, 150, 200, 280],
    'Publisher': ["O'Reilly"] * 6,
})
print(df)


"""
Example: Polars - Top Selling Books (Native API)
"""
import polars as pl

df = pl.DataFrame({
    'Title': ['Python Crash Course', 'Hands-On Machine Learning',
              'Data Science for Business', 'Learning SQL'],
    'UnitsSold': [250, 180, 320, 150],
    'Publisher': ["O'Reilly"] * 4,
})

top_selling = df.sort(by="UnitsSold", descending=True)
top_books = top_selling.select(["Title", "UnitsSold"]).head(5)
print(top_books)


"""
Example: Polars with DuckDB Integration
"""
import polars as pl
import duckdb

con = duckdb.connect()

df = pl.DataFrame({
    'Title': ['Python for Data Analysis', 'Hands-On Machine Learning',
              'Deep Learning', 'Data Science from Scratch'],
    'Author': ['Wes McKinney', 'Aurélien Géron', 
               'Ian Goodfellow', 'Joel Grus'],
    'Publisher': ["O'Reilly"] * 4,
    'Price': [39.99, 49.99, 59.99, 29.99],
    'UnitsSold': [1000, 800, 1200, 600]
})

con.register('books', df)
result = con.execute("SELECT Title, UnitsSold FROM books WHERE Publisher = 'O''Reilly'")
result_df = pl.DataFrame(result.fetchall(), schema=['Title', 'UnitsSold'])
print(result_df)
con.close()


"""
Example: Polars Native SQL Context
"""
import polars as pl

df = pl.DataFrame({
    'Title': ['Python for Data Analysis', 'Hands-On Machine Learning',
              'Deep Learning', 'Data Science from Scratch'],
    'Author': ['Wes McKinney', 'Aurélien Géron', 
               'Ian Goodfellow', 'Joel Grus'],
    'Publisher': ["O'Reilly"] * 4,
    'Price': [39.99, 49.99, 59.99, 29.99],
    'UnitsSold': [1000, 800, 1200, 600]
})

# Create SQL context and register DataFrame
sql = pl.SQLContext()
sql.register('df', df)

# Execute SQL query
result_df = sql.execute("""
    SELECT * FROM df
    WHERE Title = 'Python for Data Analysis'
""").collect()
print(result_df)
