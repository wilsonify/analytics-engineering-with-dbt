# Analytics Engineering with SQL and dbt

**Building Meaningful Data Models at Scale**  
*Based on the book by Rui Machado & Hélder Russa*

> This repository contains restructured, clear, and concise educational materials from the "Analytics Engineering with SQL and dbt" book, with all code examples extracted to separate files for easy reference and hands-on practice.

---

## Table of Contents
- [Overview](#overview)
- [What You'll Learn](#what-youll-learn)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [Chapter Guide](#chapter-guide)
- [For Different Audiences](#for-different-audiences)
- [Prerequisites](#prerequisites)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

This project provides a complete learning path for **analytics engineering** — the intersection of data engineering, data analytics, and software engineering best practices.

### What is Analytics Engineering?

Analytics engineering focuses on transforming raw data into clean, well-defined datasets that enable self-service analytics. Instead of tangled stored procedures and inefficient views, analytics engineers use modern tools like **dbt** (data build tool) to create scalable, testable, and documented data transformation pipelines.

```
┌──────────────────────────────────────────────────────────────┐
│              Analytics Engineering Pipeline                  │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Raw Data  ──▶  Transform (dbt)  ──▶  Analytics-Ready Data │
│   (Lakes)       (SQL + Jinja)          (Data Warehouse)     │
│                                                              │
│                        │                                     │
│                        ▼                                     │
│                  ┌──────────────┐                           │
│                  │   Testing    │                            │
│                  │Documentation │                            │
│                  │  Deployment  │                            │
│                  └──────────────┘                           │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## What You'll Learn

| Topic | Coverage |
|-------|----------|
| **Analytics Engineering Fundamentals** | Role, principles, lifecycle |
| **Data Modeling** | Conceptual, logical, physical, dimensional modeling |
| **SQL Mastery** | DDL, DML, window functions, CTEs, optimization |
| **dbt Framework** | Project structure, models, tests, documentation, deployment |
| **Advanced dbt** | Materializations, snapshots, Jinja, macros, packages, semantic layer |
| **End-to-End Use Case** | Complete omnichannel analytics project from scratch |

---

## Repository Structure

```
analytics-engineering-with-dbt/
│
├── readme.md                           # This file
│
└── src/
    ├── c01-Analytics Engineering/
    │   ├── readme.md                   # Chapter overview
    │   └── examples/                   # Code examples
    │
    ├── c02-Data Modeling for Analytics/
    │   ├── readme.md
    │   └── examples/
    │       ├── conceptual/             # ER diagrams
    │       ├── logical/                # Normalized schemas
    │       ├── physical/               # Platform-specific DDL
    │       └── dimensional/            # Star/snowflake schemas
    │
    ├── c03-SQL for Analytics/
    │   ├── readme.md
    │   └── examples/                   # 22 SQL/Python examples
    │       ├── 01-ddl-basics.sql
    │       ├── 02-dml-operations.sql
    │       ├── ...
    │       └── 22-ml-with-sql.sql
    │
    ├── c04-Data Transformation with dbt/
    │   ├── readme.md
    │   └── examples/
    │       ├── dbt_project.yml
    │       ├── packages.yml
    │       ├── models/                 # Staging, intermediate, marts
    │       ├── tests/                  # Data quality tests
    │       ├── analyses/               # Ad-hoc queries
    │       └── seeds/                  # CSV data
    │
    ├── c05-dbt Advanced Topics/
    │   ├── readme.md
    │   └── examples/
    │       ├── macros/                 # Reusable Jinja functions
    │       ├── models/                 # Advanced model patterns
    │       ├── semantic/               # Semantic layer configs
    │       └── packages.yml
    │
    └── c06-Building an End-to-End Analytics Engineering Use Case/
        ├── readme.md
        └── examples/
            ├── operational/            # MySQL operational database
            ├── etl/                    # Python ETL pipeline
            ├── dbt/                    # Complete dbt project
            │   ├── staging/
            │   ├── marts/
            │   └── tests/
            └── analytics/              # SQL analysis queries
```

---

## Getting Started

### For Quick Learners (15 minutes)

1. **Read Chapter 1** - Understand analytics engineering fundamentals
   - Navigate to `src/c01-Analytics Engineering/readme.md`

2. **Explore a complete example** - See the end-to-end use case
   - Navigate to `src/c06-Building an End-to-End Analytics Engineering Use Case/`
   - Review the star schema design
   - Examine example SQL queries in `examples/analytics/`

3. **Try a dbt example** - Run a simple transformation
   - Go to `src/c04-Data Transformation with dbt/examples/`
   - Review `models/staging/jaffle_shop/stg_jaffle_shop_customers.sql`

### For Comprehensive Learning (Follow in Order)

```
Chapter 1  ──▶  Chapter 2  ──▶  Chapter 3  ──▶  Chapter 4  ──▶  Chapter 5  ──▶  Chapter 6
   │              │              │              │              │              │
Foundation   Data Models    SQL Mastery   dbt Basics    dbt Advanced   Complete Project
```

1. **Chapter 1**: Analytics Engineering - Understand the role and principles
2. **Chapter 2**: Data Modeling - Learn conceptual, logical, physical, and dimensional modeling
3. **Chapter 3**: SQL - Master DDL, DML, window functions, CTEs
4. **Chapter 4**: dbt Basics - Project structure, models, tests, documentation
5. **Chapter 5**: dbt Advanced - Materializations, macros, packages, semantic layer
6. **Chapter 6**: End-to-End Use Case - Apply everything to build an omnichannel analytics solution

---

## Chapter Guide

### [Chapter 1: Analytics Engineering](src/c01-Analytics%20Engineering/readme.md)

**What You'll Learn:**
- Role and responsibilities of analytics engineers
- Analytics engineering lifecycle
- Best practices and principles

**Key Takeaway:** Analytics engineering bridges the gap between data engineering and data analysis.

---

### [Chapter 2: Data Modeling for Analytics](src/c02-Data%20Modeling%20for%20Analytics/readme.md)

**What You'll Learn:**
- Conceptual modeling (ER diagrams)
- Logical modeling (normalized schemas)
- Physical modeling (platform-specific implementations)
- Dimensional modeling (star/snowflake schemas)

**Examples:**
- 10 files covering all modeling stages
- Retail case study from conceptual to dimensional

**Key Takeaway:** Good data modeling is the foundation of effective analytics.

---

### [Chapter 3: SQL for Analytics](src/c03-SQL%20for%20Analytics/readme.md)

**What You'll Learn:**
- DDL and DML fundamentals
- Advanced querying with CTEs and window functions
- Query optimization techniques
- Alternative tools (DuckDB, Polars, FugueSQL)

**Examples:**
- 22 files with SQL and Python code
- Covers beginner to advanced patterns

**Key Takeaway:** SQL is the universal language of data analytics.

---

### [Chapter 4: Data Transformation with dbt](src/c04-Data%20Transformation%20with%20dbt/readme.md)

**What You'll Learn:**
- dbt project structure and configuration
- Creating staging, intermediate, and marts models
- Writing tests and documentation
- Deployment workflows

**Examples:**
- Complete dbt project structure
- Jaffle Shop example (staging → marts)
- YAML configurations
- Generic and singular tests

**Key Takeaway:** dbt brings software engineering best practices to data transformations.

---

### [Chapter 5: dbt Advanced Topics](src/c05-dbt%20Advanced%20Topics/readme.md)

**What You'll Learn:**
- Model materializations (table, view, incremental, ephemeral)
- Snapshots for slowly changing dimensions
- Dynamic SQL with Jinja
- SQL macros for code reuse
- dbt packages (dbt_utils, dbt_date)
- Semantic layer and MetricFlow

**Examples:**
- 15 files covering all advanced patterns
- Macros directory with reusable functions
- Semantic model configurations

**Key Takeaway:** Advanced dbt features enable enterprise-scale analytics engineering.

---

### [Chapter 6: Building an End-to-End Analytics Engineering Use Case](src/c06-Building%20an%20End-to-End%20Analytics%20Engineering%20Use%20Case/readme.md)

**What You'll Learn:**
- Complete omnichannel analytics project
- Operational database design (MySQL)
- ETL pipeline (Python → BigQuery)
- Star schema implementation with dbt
- Testing and documentation
- SQL analytics on dimensional model

**Examples:**
- 31 files across operational/ETL/dbt/analytics
- MySQL → BigQuery pipeline
- Complete star schema (4 dimensions, 2 facts)
- Production-ready tests and documentation

**Key Takeaway:** Putting it all together - from problem definition to analytics insights.

---

## For Different Audiences

### 🎓 Data Analysts

**Start Here:**
1. Chapter 1 (analytics engineering overview)
2. Chapter 3 (SQL mastery)
3. Chapter 4 (dbt basics)
4. Chapter 6 (end-to-end use case)

**Focus On:**
- SQL querying techniques
- dbt model creation
- Testing data transformations
- Documentation practices

---

### 💻 Data Engineers

**Start Here:**
1. Chapter 2 (data modeling)
2. Chapter 4 (dbt basics)
3. Chapter 5 (dbt advanced)
4. Chapter 6 (end-to-end use case)

**Focus On:**
- Physical data modeling
- Incremental materializations
- Snapshot patterns
- Macro development
- Pipeline orchestration

---

### 📊 BI Developers

**Start Here:**
1. Chapter 2 (dimensional modeling)
2. Chapter 3 (SQL for analytics)
3. Chapter 5 (semantic layer)
4. Chapter 6 (analytics queries)

**Focus On:**
- Star schema design
- Semantic layer configuration
- Metrics definitions
- Query optimization

---

### 🔬 Data Scientists

**Start Here:**
1. Chapter 3 (SQL including ML with SQL)
2. Chapter 4 (dbt basics)
3. Chapter 6 (use case)

**Focus On:**
- Feature engineering with SQL
- Data preparation pipelines
- Documentation for reproducibility
- Integration with ML workflows

---

### 👨‍�� Project Managers / Admins

**Start Here:**
1. Chapter 1 (analytics engineering principles)
2. Chapter 4 (dbt project structure)
3. Chapter 6 (complete project lifecycle)

**Focus On:**
- Understanding the analytics engineering role
- Project organization and structure
- Testing and deployment workflows
- Documentation for team collaboration

---

## Prerequisites

### Required Knowledge

| Level | Topics |
|-------|--------|
| **Basic** | SQL fundamentals (SELECT, WHERE, JOIN) |
| **Intermediate** | Git/GitHub basics, command line familiarity |
| **Advanced** | Python (for ETL examples), cloud platforms (BigQuery/Snowflake) |

### Software Requirements

| Tool | Purpose | Installation |
|------|---------|--------------|
| **Git** | Version control | [git-scm.com](https://git-scm.com/) |
| **Python 3.8+** | ETL scripts | [python.org](https://www.python.org/) |
| **dbt** | Data transformations | [docs.getdbt.com](https://docs.getdbt.com/docs/get-started/installation) |
| **Database** | One of: BigQuery, Snowflake, PostgreSQL, DuckDB | Platform-specific |

### Optional Tools

- **VS Code** - Recommended IDE with SQL/dbt extensions
- **DBeaver** / **DataGrip** - Database GUI clients
- **Docker** - For local database environments

---

## Running Examples

### Chapter 3 - SQL Examples

```bash
# Example: Run DDL basics (requires database connection)
cd "src/c03-SQL for Analytics/examples"

# PostgreSQL
psql -U username -d database -f 01-ddl-basics.sql

# BigQuery
bq query < 01-ddl-basics.sql

# DuckDB (standalone)
duckdb < 14-duckdb-basics.sql
```

### Chapter 4 & 5 - dbt Examples

```bash
# Navigate to dbt project
cd "src/c04-Data Transformation with dbt/examples"

# Install dependencies
dbt deps

# Run models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
```

### Chapter 6 - Complete Use Case

```bash
# 1. Set up operational database (MySQL)
mysql -u root -p < "src/c06-Building an End-to-End Analytics Engineering Use Case/examples/operational/01-create-database.sql"

# 2. Run ETL pipeline (Python)
cd "src/c06-Building an End-to-End Analytics Engineering Use Case/examples/etl"
python 05-run-pipeline.py

# 3. Transform with dbt
cd "src/c06-Building an End-to-End Analytics Engineering Use Case/examples/dbt"
dbt deps
dbt build

# 4. Run analytics queries (BigQuery)
bq query < "../analytics/01-total-amount-per-quarter.sql"
```

---

## Key Concepts Reference

### Data Modeling Types

| Type | Purpose | Output |
|------|---------|--------|
| **Conceptual** | High-level entities and relationships | ER diagram |
| **Logical** | Normalized table structure | Schema definition |
| **Physical** | Platform-specific implementation | DDL scripts |
| **Dimensional** | Analytics-optimized model | Star/snowflake schema |

### dbt Materializations

| Type | Storage | Use Case |
|------|---------|----------|
| **view** | Virtual | Light transformations, always fresh |
| **table** | Physical | Heavy transformations, stable data |
| **incremental** | Physical (append) | Large tables, event data |
| **ephemeral** | CTE only | Intermediate logic |

### SQL Best Practices

- Use **CTEs** for readability over nested subqueries
- Leverage **window functions** for rankings and running totals
- Apply **WHERE** before **GROUP BY** for performance
- Use **meaningful aliases** for clarity
- Add **indexes** on frequently joined columns

### dbt Best Practices

- **Staging models** - One per source table, minimal transformations
- **Intermediate models** - Business logic, ephemeral when possible
- **Marts models** - Analytics-ready, tables or views
- **Tests** - At least `unique` and `not_null` on keys
- **Documentation** - YAML files for all models and columns

---

## Contributing

This repository is educational and based on published book content. Contributions welcome for:

- Fixing typos or errors
- Improving explanations
- Adding additional examples
- Updating for newer dbt versions

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Make your changes
4. Commit with clear messages (`git commit -m "Fix typo in Chapter 3"`)
5. Push to your fork (`git push origin feature/improvement`)
6. Open a Pull Request

---

## License

This repository contains educational materials based on "Analytics Engineering with SQL and dbt" by Rui Machado & Hélder Russa. The restructured content and examples are provided for learning purposes.

**Original Book:**
- **Authors**: Rui Machado (VP Technology, Fraudio) & Hélder Russa (Head of Data Engineering, Jumia)
- **Publisher**: O'Reilly Media
- **Purchase**: [Available at O'Reilly](https://www.oreilly.com/)

---

## Additional Resources

### Official Documentation

- [dbt Documentation](https://docs.getdbt.com/)
- [dbt Discourse Community](https://discourse.getdbt.com/)
- [dbt Package Hub](https://hub.getdbt.com/)

### Learning Resources

- [dbt Learn](https://learn.getdbt.com/) - Free dbt courses
- [Kimball Group](https://www.kimballgroup.com/) - Dimensional modeling
- [Mode Analytics SQL Tutorial](https://mode.com/sql-tutorial/) - SQL practice

### Communities

- [dbt Slack Community](https://www.getdbt.com/community/join-the-community)
- [r/dataengineering](https://www.reddit.com/r/dataengineering/)
- [Locally Optimistic](https://locallyoptimistic.com/) - Analytics engineering blog

---

## Quick Start Checklist

- [ ] Clone this repository
- [ ] Read Chapter 1 for context
- [ ] Install dbt for your data platform
- [ ] Run a simple dbt example from Chapter 4
- [ ] Explore the complete use case in Chapter 6
- [ ] Apply concepts to your own projects

---

**Happy Learning! 🚀**

*From raw data to actionable insights - master the complete analytics engineering workflow.*
