# Chapter 3: SQL for Analytics

## Table of Contents

- [Overview](#overview)
- [SQL Fundamentals](#sql-fundamentals)
  - [The DIKW Pyramid](#the-dikw-pyramid)
  - [Database Types](#database-types)
- [Data Definition Language (DDL)](#data-definition-language-ddl)
- [Data Manipulation Language (DML)](#data-manipulation-language-dml)
  - [INSERT](#insert)
  - [SELECT](#select)
  - [WHERE Clause](#where-clause)
  - [GROUP BY](#group-by)
  - [ORDER BY](#order-by)
  - [JOINs](#joins)
  - [UPDATE](#update)
  - [DELETE](#delete)
- [Views](#views)
- [Common Table Expressions (CTEs)](#common-table-expressions-ctes)
- [Window Functions](#window-functions)
- [Distributed SQL](#distributed-sql)
  - [DuckDB](#duckdb)
  - [Polars](#polars)
  - [FugueSQL](#fuguesql)
- [Bonus: ML with SQL](#bonus-ml-with-sql)
- [Summary](#summary)
- [Examples](#examples)

---

## Overview

SQL remains the most resilient and widely-used language for data manipulation. Despite decades of evolution in database technology, SQL continues to be the standard interface for analytics work.

```
┌─────────────────────────────────────────────────────────────────┐
│                     SQL in Analytics                            │
├─────────────────────────────────────────────────────────────────┤
│  Traditional DB  ──►  Data Warehouse  ──►  Distributed SQL      │
│     (OLTP)              (OLAP)             (DuckDB, Spark)       │
│                                                                 │
│  Same SQL syntax, different scale and optimization              │
└─────────────────────────────────────────────────────────────────┘
```

---

## SQL Fundamentals

### The DIKW Pyramid

The hierarchy of transforming raw data into actionable insight:

| Level | Description | Example |
|-------|-------------|---------|
| **Data** | Raw facts and figures | Sales transactions |
| **Information** | Organized, contextualized data | Daily sales totals |
| **Knowledge** | Patterns and insights | Seasonal trends |
| **Wisdom** | Applied knowledge for decisions | Inventory strategy |

### Database Types

| Type | Characteristics | Examples | Use Case |
|------|-----------------|----------|----------|
| **Relational (SQL)** | Structured, ACID, schemas | PostgreSQL, MySQL | Transactional systems |
| **Document** | Flexible schemas, JSON/BSON | MongoDB, CouchDB | Content management |
| **Key-Value** | Simple, fast lookups | Redis, DynamoDB | Caching, sessions |
| **Graph** | Relationship-focused | Neo4j, Neptune | Social networks |
| **Columnar** | Column-oriented storage | Cassandra, HBase | Analytics, time-series |

---

## Data Definition Language (DDL)

DDL commands define and modify database structure.

| Command | Purpose | Example |
|---------|---------|---------|
| `CREATE` | Create database objects | `CREATE TABLE books (...)` |
| `DROP` | Remove objects permanently | `DROP TABLE books` |
| `ALTER` | Modify existing objects | `ALTER TABLE books ADD COLUMN isbn VARCHAR(20)` |
| `RENAME` | Rename objects | `RENAME TABLE books TO library_books` |
| `TRUNCATE` | Remove all rows (keep structure) | `TRUNCATE TABLE books` |
| `CONSTRAINT` | Add data integrity rules | `ADD CONSTRAINT unique_isbn UNIQUE (isbn)` |
| `INDEX` | Create/drop indexes | `CREATE INDEX idx_year ON books (publication_year)` |

 **Examples:** [01-create-database.sql](examples/01-create-database.sql) | [02-create-tables.sql](examples/02-create-tables.sql) | [03-drop-table.sql](examples/03-drop-table.sql) | [04-alter-table.sql](examples/04-alter-table.sql) | [05-rename-truncate.sql](examples/05-rename-truncate.sql) | [06-constraints.sql](examples/06-constraints.sql) | [07-index.sql](examples/07-index.sql)

---

## Data Manipulation Language (DML)

DML commands manipulate data within tables.

### INSERT

Add new records to a table.

```sql
INSERT INTO books (book_id, book_title, publication_year)
VALUES (1, 'The Shining', 1977);
```

 **Example:** [08-insert.sql](examples/08-insert.sql)

### SELECT

Retrieve data from tables.

```sql
SELECT book_title, publication_year FROM books;
```

 **Example:** [09-select-basic.sql](examples/09-select-basic.sql)

### WHERE Clause

Filter results using conditions.

| Operator Type | Operators | Example |
|--------------|-----------|---------|
| **Comparison** | `=`, `!=`, `<`, `>`, `<=`, `>=` | `WHERE price > 20` |
| **Logical** | `AND`, `OR`, `NOT` | `WHERE price > 20 AND year > 2000` |
| **Range** | `BETWEEN` | `WHERE year BETWEEN 1980 AND 2000` |
| **List** | `IN` | `WHERE year IN (1974, 1986)` |
| **Pattern** | `LIKE` | `WHERE title LIKE 'The%'` |
| **Null Check** | `IS NULL`, `IS NOT NULL` | `WHERE author_id IS NOT NULL` |

 **Example:** [10-where-clause.sql](examples/10-where-clause.sql)

### GROUP BY

Aggregate data into groups.

| Function | Purpose |
|----------|---------|
| `COUNT()` | Number of rows |
| `SUM()` | Total of values |
| `AVG()` | Average value |
| `MIN()` | Minimum value |
| `MAX()` | Maximum value |

Use `HAVING` to filter groups (vs. `WHERE` which filters rows).

 **Example:** [11-group-by.sql](examples/11-group-by.sql)

### ORDER BY

Sort results ascending (`ASC`) or descending (`DESC`).

```sql
SELECT * FROM books ORDER BY publication_year DESC;
```

 **Example:** [12-order-by.sql](examples/12-order-by.sql)

### JOINs

Combine data from multiple tables.

```
┌─────────────────────────────────────────────────────────────────┐
│                         JOIN Types                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  INNER JOIN        LEFT JOIN         RIGHT JOIN    FULL OUTER  │
│    ┌───┐            ┌───┐             ┌───┐          ┌───┐     │
│   ╱ A ╲            ╱█A█╲             ╱ A ╲          ╱█A█╲      │
│  │  █  │          │  █  │           │  █  │        │  █  │     │
│   ╲ B ╱            ╲ B ╱             ╲█B█╱          ╲█B█╱      │
│    └───┘            └───┘             └───┘          └───┘     │
│  Matching only    A + matching      B + matching   All rows    │
│                                                                 │
│  CROSS JOIN: Cartesian product (every A row × every B row)     │
└─────────────────────────────────────────────────────────────────┘
```

| Join Type | Returns |
|-----------|---------|
| `INNER JOIN` | Only matching rows from both tables |
| `LEFT JOIN` | All rows from left table + matching from right |
| `RIGHT JOIN` | All rows from right table + matching from left |
| `FULL OUTER JOIN` | All rows from both tables |
| `CROSS JOIN` | Cartesian product of both tables |

 **Example:** [13-joins.sql](examples/13-joins.sql)

### UPDATE

Modify existing records.

```sql
UPDATE books SET price = 29.99 WHERE book_id = 1;
```

 **Example:** [14-update.sql](examples/14-update.sql)

### DELETE

Remove records from a table.

```sql
DELETE FROM books WHERE publication_year < 1980;
```

 **Example:** [15-delete.sql](examples/15-delete.sql)

---

## Views

Views are virtual tables defined by a query. They simplify complex queries and provide a layer of abstraction.

**Benefits:**
- Simplify complex queries
- Provide security (expose only needed columns)
- Maintain backward compatibility during schema changes

```sql
CREATE VIEW recent_books AS
SELECT book_id, book_title, publication_year
FROM books WHERE publication_year >= 2000;
```

 **Example:** [16-views.sql](examples/16-views.sql)

---

## Common Table Expressions (CTEs)

CTEs create named temporary result sets within a query. They improve readability and enable recursive queries.

```sql
WITH author_stats AS (
    SELECT author_id, COUNT(*) AS book_count
    FROM books GROUP BY author_id
)
SELECT a.name, s.book_count
FROM authors a JOIN author_stats s ON a.id = s.author_id;
```

| CTE Type | Use Case |
|----------|----------|
| **Simple CTE** | Break complex queries into readable parts |
| **Multiple CTEs** | Chain multiple temporary result sets |
| **Recursive CTE** | Traverse hierarchical data (org charts, categories) |

 **Example:** [17-ctes.sql](examples/17-ctes.sql)

---

## Window Functions

Window functions perform calculations across a set of rows related to the current row, without collapsing results like `GROUP BY`.

```
┌─────────────────────────────────────────────────────────────────┐
│          function() OVER (                                      │
│              [PARTITION BY column]                              │
│              [ORDER BY column]                                  │
│              [ROWS/RANGE frame_clause]                          │
│          )                                                      │
└─────────────────────────────────────────────────────────────────┘
```

| Category | Functions | Purpose |
|----------|-----------|---------|
| **Ranking** | `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE()` | Assign positions |
| **Navigation** | `LAG()`, `LEAD()`, `FIRST_VALUE()`, `LAST_VALUE()` | Access adjacent rows |
| **Aggregate** | `SUM()`, `AVG()`, `COUNT()`, `MIN()`, `MAX()` | Running calculations |

**RANK vs ROW_NUMBER vs DENSE_RANK:**

| Value | ROW_NUMBER | RANK | DENSE_RANK |
|-------|------------|------|------------|
| 100 | 1 | 1 | 1 |
| 100 | 2 | 1 | 1 |
| 90 | 3 | 3 | 2 |
| 80 | 4 | 4 | 3 |

 **Example:** [18-window-functions.sql](examples/18-window-functions.sql)

---

## Distributed SQL

As data scales beyond single machines, distributed SQL interfaces provide familiar syntax with distributed processing power.

```
┌─────────────────────────────────────────────────────────────────┐
│                    SQL Interface Layer                          │
│         (DuckDB, Polars, FugueSQL, Spark SQL)                   │
├─────────────────────────────────────────────────────────────────┤
│                 Distributed Processing Layer                    │
│              (Spark, Dask, Ray, DuckDB Engine)                  │
├─────────────────────────────────────────────────────────────────┤
│                    Storage Layer                                │
│        (Parquet, CSV, Cloud Storage, Databases)                 │
└─────────────────────────────────────────────────────────────────┘
```

### DuckDB

An in-process analytical database with excellent pandas integration.

**Key Features:**
- No server required (embedded)
- OLAP-optimized (columnar, vectorized)
- Direct pandas DataFrame integration
- Postgres SQL compatibility

```bash
pip install duckdb
```

```python
import duckdb
import pandas as pd

df = pd.DataFrame({'a': [1, 2, 3]})
result = duckdb.query("SELECT SUM(a) FROM df").to_df()
```

 **Example:** [19-duckdb.py](examples/19-duckdb.py)

### Polars

A high-performance DataFrame library written in Rust.

**Key Features:**
- No DataFrame index (simpler API)
- Apache Arrow memory format
- Parallel operations
- Lazy evaluation with query optimization

```bash
pip install polars
```

```python
import polars as pl

df = pl.DataFrame({'Title': ['Book A', 'Book B'], 'Sales': [100, 200]})

# Native SQL context
sql = pl.SQLContext()
sql.register('df', df)
result = sql.execute("SELECT * FROM df WHERE Sales > 150").collect()
```

 **Example:** [20-polars.py](examples/20-polars.py)

### FugueSQL

A unified SQL interface that runs on pandas, Spark, Dask, or Ray.

**Key Features:**
- Same SQL code on multiple engines
- Seamless engine switching
- Integration with distributed frameworks

```bash
pip install "fugue[sql]"
pip install "fugue[spark]"     # For Spark support
pip install "fugue[duckdb]"    # For DuckDB support
```

```python
import fugue.api as fa

query = """
    LOAD "/tmp/data.parquet"
    SELECT Author, COUNT(*) AS BookCount
    GROUP BY Author
    PRINT
"""

# Run on different engines
fa.fugue_sql(query, engine="pandas")
fa.fugue_sql(query, engine="spark")
fa.fugue_sql(query, engine="duckdb")
```

�� **Example:** [21-fuguesql.py](examples/21-fuguesql.py)

---

## Bonus: ML with SQL

**dask-sql** (experimental) enables machine learning workflows using SQL syntax.

```bash
pip install dask-sql
```

```python
from dask_sql import Context
import dask.dataframe as dd

c = Context()
df = dd.read_csv('https://datahub.io/machine-learning/iris/r/iris.csv')
c.create_table("iris", df)

# Train a model with SQL
c.sql("""
    CREATE OR REPLACE MODEL clustering WITH (
        model_class = 'sklearn.cluster.KMeans',
        n_clusters = 3
    ) AS (
        SELECT sepallength, sepalwidth, petallength, petalwidth
        FROM iris
    )
""")

# Make predictions
c.sql("""
    SELECT * FROM PREDICT (
        MODEL clustering,
        SELECT * FROM iris LIMIT 100
    )
""")
```

 **Example:** [22-ml-with-sql.py](examples/22-ml-with-sql.py)

---

## Summary

| Concept | Key Points |
|---------|------------|
| **DDL** | CREATE, DROP, ALTER, RENAME, TRUNCATE, CONSTRAINT, INDEX |
| **DML** | INSERT, SELECT, UPDATE, DELETE |
| **Filtering** | WHERE with comparison, logical, range, pattern operators |
| **Aggregation** | GROUP BY + aggregate functions + HAVING |
| **Joins** | INNER, LEFT, RIGHT, FULL OUTER, CROSS |
| **Views** | Virtual tables from saved queries |
| **CTEs** | Named temporary result sets; supports recursion |
| **Window Functions** | Ranking, navigation, running aggregates over partitions |
| **Distributed SQL** | DuckDB (embedded), Polars (Rust), FugueSQL (multi-engine) |

**Key Takeaways:**
1. SQL remains the universal language for data manipulation
2. Master DDL for structure, DML for data operations
3. Views and CTEs improve query organization and reusability
4. Window functions enable powerful analytics without subqueries
5. Distributed SQL tools extend SQL to big data with familiar syntax

---

## Examples

All code examples are in the [examples/](examples/) directory:

| File | Description |
|------|-------------|
| [01-create-database.sql](examples/01-create-database.sql) | CREATE DATABASE |
| [02-create-tables.sql](examples/02-create-tables.sql) | CREATE TABLE with keys |
| [03-drop-table.sql](examples/03-drop-table.sql) | DROP TABLE |
| [04-alter-table.sql](examples/04-alter-table.sql) | ALTER TABLE operations |
| [05-rename-truncate.sql](examples/05-rename-truncate.sql) | RENAME and TRUNCATE |
| [06-constraints.sql](examples/06-constraints.sql) | UNIQUE and CHECK constraints |
| [07-index.sql](examples/07-index.sql) | CREATE/DROP INDEX |
| [08-insert.sql](examples/08-insert.sql) | INSERT statements |
| [09-select-basic.sql](examples/09-select-basic.sql) | Basic SELECT queries |
| [10-where-clause.sql](examples/10-where-clause.sql) | WHERE with operators |
| [11-group-by.sql](examples/11-group-by.sql) | GROUP BY and aggregates |
| [12-order-by.sql](examples/12-order-by.sql) | ORDER BY sorting |
| [13-joins.sql](examples/13-joins.sql) | All JOIN types |
| [14-update.sql](examples/14-update.sql) | UPDATE statements |
| [15-delete.sql](examples/15-delete.sql) | DELETE statements |
| [16-views.sql](examples/16-views.sql) | CREATE/DROP VIEW |
| [17-ctes.sql](examples/17-ctes.sql) | CTEs and recursion |
| [18-window-functions.sql](examples/18-window-functions.sql) | Window functions |
| [19-duckdb.py](examples/19-duckdb.py) | DuckDB with Python |
| [20-polars.py](examples/20-polars.py) | Polars DataFrame + SQL |
| [21-fuguesql.py](examples/21-fuguesql.py) | FugueSQL multi-engine |
| [22-ml-with-sql.py](examples/22-ml-with-sql.py) | ML with dask-sql |

---

[← Chapter 2: Data Modeling](../c02-Data%20Modeling%20for%20Analytics/readme.md) | [Chapter 4: Data Transformation with dbt →](../c04-Data%20Transformation%20with%20dbt/readme.md)
