# Chapter 2: Data Modeling for Analytics

## Table of Contents

- [Introduction](#introduction)
- [Data Modeling Phases](#a-brief-on-data-modeling)
- [Data Normalization](#the-data-normalization-process)
- [Dimensional Modeling](#dimensional-data-modeling)
- [Modular Data Models](#building-modular-data-models)
- [dbt Model Layers](#enabling-modular-data-models-with-dbt)
- [Testing and Documentation](#testing-your-data-models)
- [Debugging and Optimization](#debugging-and-optimizing-data-models)
- [Medallion Architecture](#medallion-architecture-pattern)
- [Summary](#summary)

---

## Introduction

Data modeling defines the structure, relationships, and attributes of data entities within a system. It provides the foundation for effective analytics by enabling analysts to:
- Perform complex queries
- Join tables correctly
- Aggregate data for meaningful insights

**Data normalization** eliminates redundancy and improves integrity by organizing data into separate, logical tables.

### Why SQL and dbt?

| Tool | Role |
|------|------|
| **SQL** | Define tables, manipulate data, articulate relationships |
| **dbt** | Build pipelines, apply business rules, create reusable models, integrate with version control |

Together, they enable robust, scalable, maintainable data models with built-in testing and documentation.

---

## A Brief on Data Modeling

Before creating a data model, understand the business: operations, terminology, processes, and requirements. Express business facts in clear, unambiguous sentences.

### Three Phases of Database Modeling

```
Conceptual -> Logical -> Physical
```

### The Conceptual Phase

**Goal:** Identify entities, relationships, and attributes.

**Steps:**
1. Identify database purpose and goals
2. Gather requirements from stakeholders
3. Analyze and define entities
4. Identify relationships and cardinality
5. Create Entity-Relationship Diagrams (ERD)

**Example: Book Publisher Database**

| Entity | Attributes |
|--------|------------|
| Book | book_id, title, publication_date, ISBN, price, category |
| Author | author_id, author_name, email, bio |
| Category | category_id, category_name |

**Relationship Types (Cardinality):**

| Type | Example |
|------|---------|
| One-to-One | One book has one author |
| One-to-Many | One category has many books |
| Many-to-One | Many books have one publisher |
| Many-to-Many | Many books have many authors |

### The Logical Phase

**Goal:** Normalize data and translate ERD to a specific model (e.g., relational).

**Translation rules:**
- Entity E becomes Table T
- Primary key of E becomes Primary key of T
- Simple attributes of E become Columns of T

**Relationship handling:**

| Relationship | Implementation |
|--------------|----------------|
| N:1 | Foreign key in T1 referencing T2 |
| N:N | Cross-reference table with composite primary key |

### The Physical Phase

**Goal:** Convert logical model to actual database implementation with specific data types, constraints, and storage structures.

```sql
CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255)
);

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    ISBN VARCHAR(13),
    title VARCHAR(50),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(255),
    date_birth DATETIME
);

CREATE TABLE publishes (
    book_id INT,
    author_id INT,
    publish_date DATE,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);
```

---

## The Data Normalization Process

Normalization organizes data into logical, efficient structures by eliminating redundancy.

### Normal Forms

| Form | Goal | Action |
|------|------|--------|
| **1NF** | Eliminate repeating groups | Break data into atomic units |
| **2NF** | Remove partial dependencies | Each column depends on the whole primary key |
| **3NF** | Remove transitive dependencies | No column depends on non-key columns |

### Example Progression

**Unnormalized:**
```
| book_id | title | author_name | publication_year | genre |
```

**1NF:** Separate authors table, reference by author_id

**2NF:** Split into books, authors, bookDetails tables

**3NF:** Create genres table, reference by genre_id

### OLTP vs. Analytics

| Aspect | OLTP | Analytics |
|--------|------|-----------|
| Optimization | Write operations | Read operations |
| Data | Current only | Historical + current |
| Joins | Many (normalized) | Fewer preferred |
| Sources | Single system | Multiple systems integrated |

---

## Dimensional Data Modeling

Dimensional modeling supports analytics and reporting by organizing data into **fact tables** (measurements) and **dimension tables** (context).

### Pioneers

- **Bill Inmon:** Centralized enterprise data warehouse using 3NF
- **Ralph Kimball:** Departmental data marts using star/snowflake schemas

### Star Schema

The most common dimensional modeling approach.

**Components:**
- **Fact tables:** Store measurable events (sales, orders, temperatures)
- **Dimension tables:** Describe business entities (products, customers, dates)

```sql
-- Dimension tables
CREATE TABLE dimBooks (
    book_id INT PRIMARY KEY,
    title VARCHAR(100)
);

CREATE TABLE dimAuthors (
    author_id INT PRIMARY KEY,
    author VARCHAR(100)
);

CREATE TABLE dimGenres (
    genre_id INT PRIMARY KEY,
    genre VARCHAR(50)
);

-- Fact table
CREATE TABLE factBookPublish (
    book_id INT,
    author_id INT,
    genre_id INT,
    publication_year INT,
    FOREIGN KEY (book_id) REFERENCES dimBooks(book_id),
    FOREIGN KEY (author_id) REFERENCES dimAuthors(author_id),
    FOREIGN KEY (genre_id) REFERENCES dimGenres(genre_id)
);
```

**Querying a star schema:**
```sql
SELECT COALESCE(dg.genre, 'Not Available') AS genre,
       COUNT(*) AS total_publications
FROM factBookPublish bp
LEFT JOIN dimGenres dg ON dg.genre_id = bp.genre_id
GROUP BY dg.genre;
```

> **Note:** Use LEFT JOIN to retain all fact records even without matching dimensions.

### Snowflake Schema

Normalizes dimension tables into multiple related tables.

**Example:** Location dimension split into:
- dimLocation -> dimCity -> dimState -> dimCountry

**Trade-offs:**

| Star Schema | Snowflake Schema |
|-------------|------------------|
| Simpler queries | Better data integrity |
| Fewer JOINs | Less redundancy |
| More storage | More complex queries |

### Data Vault

A flexible approach combining 3NF and dimensional concepts.

**Components:**

| Component | Purpose |
|-----------|---------|
| **Hubs** | Store unique business keys (entities) |
| **Links** | Capture relationships between entities |
| **Satellites** | Store descriptive/historical attributes |

```sql
-- Hub table
CREATE TABLE hubBooks (
    bookKey INT PRIMARY KEY,
    bookHashKey VARCHAR(255),
    title VARCHAR(100)
);

-- Satellite table
CREATE TABLE satBookDetails (
    bookDetailKey INT PRIMARY KEY,
    bookKey INT,
    author VARCHAR(100),
    publicationYear INT,
    genre VARCHAR(50),
    loadDate DATETIME,
    FOREIGN KEY (bookKey) REFERENCES hubBooks(bookKey)
);
```

**Best for:** Environments with rapidly changing data sources.

---

## Building Modular Data Models

### The Problem with Monolithic Models

Traditional approach: Single SQL files spanning thousands of lines with:
- No version control
- Hidden dependencies
- No reusability
- Difficult debugging
- Tightly coupled components

**Result:** One change can cascade errors throughout the entire system.

### Benefits of Modularization

| Benefit | Description |
|---------|-------------|
| Manageability | Smaller, focused components |
| Team collaboration | Parallel development |
| Code quality | Isolated testing and debugging |
| Reusability | Share proven modules |
| Readability | Organized by function |
| Reliability | Fewer errors, easier maintenance |

### Core Principles

1. **Decomposition:** Break into smaller, manageable components
2. **Abstraction:** Hide implementation behind interfaces
3. **Reusability:** Create components usable across the system

---

## Enabling Modular Data Models with dbt

dbt transforms monolithic data modeling into modular, reusable components.

### Model Referencing

Use `{{ ref() }}` to establish dependencies between models:

```sql
-- orders.sql
SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    c.email
FROM {{ ref('orders') }} o
LEFT JOIN {{ ref('customers') }} c ON o.customer_id = c.customer_id
```

Use `{{ source() }}` only for initial raw data selection.

### Model Layers

#### Staging Models (stg_)

**Purpose:** 1:1 mapping to source tables with minimal transformation.

**Acceptable transformations:**
- Type conversion
- Column renaming
- Basic calculations (unit conversion)
- Simple categorization (CASE WHEN)

**Materialization:** Views (preserve timeliness, optimize storage)

```sql
-- stg_books.sql
SELECT
    book_id,
    title,
    CAST(publication_year AS INT) AS publication_year,
    UPPER(genre) AS genre
FROM {{ source('raw', 'raw_books') }}
```

> **Avoid:** Joins and aggregations in staging layer.

#### Intermediate Models (int_)

**Purpose:** Combine staging models into meaningful business constructs.

**Materialization:** Ephemeral (CTEs) or views

```sql
-- int_book_authors.sql
WITH books AS (
    SELECT * FROM {{ ref('stg_books') }}
),
authors AS (
    SELECT * FROM {{ ref('stg_authors') }}
)
SELECT
    b.book_id,
    b.title,
    a.author_id,
    a.author_name
FROM books b
JOIN authors a ON b.author_id = a.author_id
```

#### Mart Models (mart_ or fct_/dim_)

**Purpose:** Business-ready entities for dashboards and applications.

**Materialization:** Tables (or incremental for large datasets)

```sql
-- mart_author_book_counts.sql
{{ config(materialized='table', unique_key='author_id') }}

WITH book_counts AS (
    SELECT 
        author_id,
        COUNT(*) AS book_count
    FROM {{ ref('stg_books') }}
    GROUP BY author_id
)
SELECT * FROM book_counts
```

### dbt DAG Structure

```
Sources -> Staging -> Intermediate -> Marts
   |          |            |            |
 raw_*      stg_*        int_*     mart_*/fct_*/dim_*
```

---

## Testing Your Data Models

dbt provides two test types:

### Singular Tests

Specific SQL queries stored in separate files:

```sql
-- tests/not_null_book_title.sql
SELECT *
FROM {{ ref('stg_books') }}
WHERE title IS NULL
```

Test passes if query returns zero rows.

### Generic Tests

Reusable tests defined in YAML:

```yaml
# models/schema.yml
version: 2

models:
  - name: stg_books
    columns:
      - name: book_id
        tests:
          - unique
          - not_null
      - name: publication_year
        tests:
          - not_null
```

**Built-in generic tests:**
- `unique`
- `not_null`
- `accepted_values`
- `relationships`

---

## Generating Data Documentation

Document models with comments and Markdown:

```sql
-- nps_metrics.sql
/*
# NPS (Net Promoter Score) Metrics

**Dependencies:** survey_responses, customers

**Calculation:**
- Promoters: score >= 9
- Detractors: score <= 6
- NPS = % Promoters - % Detractors
*/

SELECT ...
```

**Generate documentation:**
```bash
dbt docs generate
dbt docs serve
```

---

## Debugging and Optimizing Data Models

### Query Optimization

**Strategy:** Deconstruct complex queries into CTEs:

```sql
-- Before: Single complex query
SELECT category, SUM(amount)
FROM orders o
JOIN products p ON o.product_id = p.id
JOIN categories c ON p.category_id = c.id
WHERE o.date > '2023-01-01'
GROUP BY category
HAVING SUM(amount) > 1000;

-- After: Deconstructed into CTEs
WITH join_query AS (
    SELECT o.amount, c.category, o.date
    FROM orders o
    JOIN products p ON o.product_id = p.id
    JOIN categories c ON p.category_id = c.id
),
filter_query AS (
    SELECT * FROM join_query
    WHERE date > '2023-01-01'
),
aggregate_query AS (
    SELECT category, SUM(amount) AS total
    FROM filter_query
    GROUP BY category
    HAVING SUM(amount) > 1000
)
SELECT * FROM aggregate_query;
```

### Materialization Strategy

| Query Type | Materialization |
|------------|-----------------|
| Light computation | View |
| Heavy computation | Table |
| Large incremental data | Incremental |

### Debugging Incremental Models

```bash
# Full refresh to validate
dbt run --full-refresh --select my_model

# Compare incremental vs. full results
```

---

## Medallion Architecture Pattern

A data modeling paradigm for **lakehouses** that iteratively improves data quality across layers.

### Context: Data Lakehouse

Combines strengths of data lakes and data warehouses:
- ACID transactions
- Schema enforcement
- Direct BI tool support
- Decoupled storage/compute
- Support for diverse data types

**Open formats:** Delta Lake, Apache Iceberg, Apache Hudi

### Three Layers

```
Bronze -> Silver -> Gold
   |         |        |
  Raw     Refined   Business
```

| Layer | Purpose | Characteristics |
|-------|---------|-----------------|
| **Bronze** | Raw data landing | Mirrors source structure, CDC, historical archive |
| **Silver** | Cleansed and conformed | Master data, deduplication, business entities |
| **Gold** | Business aggregations | BI-ready, ML features, KPIs |

### Relationship to dbt

```
Bronze     ->    Silver      ->     Gold
   |                |                 |
staging      intermediate          marts
```

> **Note:** Medallion architecture guides data organization; dimensional modeling techniques (star, snowflake, Data Vault) can be applied within each layer.

---

## Summary

### Key Modeling Approaches

| Approach | Best For |
|----------|----------|
| **Star Schema** | Simple queries, BI tools |
| **Snowflake Schema** | Data integrity, complex hierarchies |
| **Data Vault** | Rapidly changing sources, auditability |
| **Medallion** | Lakehouse environments, iterative refinement |

### Analytics Engineer's Role

- Design and implement appropriate data models
- Ensure optimal data organization
- Create coherent datasets from diverse sources
- Enable accurate insights and decision-making

### Key Takeaways

1. **Start with business understanding** before modeling
2. **Choose the right modeling approach** for your use case
3. **Embrace modularity** with staging -> intermediate -> mart layers
4. **Test and document** throughout the process
5. **Optimize** with appropriate materialization strategies

---

*Previous: [Chapter 1 - Analytics Engineering](../c01-Analytics%20Engineering/readme.md)*

*Next: [Chapter 3 - SQL for Analytics](../c03-SQL%20for%20Analytics/readme.md)*
