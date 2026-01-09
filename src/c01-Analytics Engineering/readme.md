# Chapter 1: Analytics Engineering

## Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Make utility

### Initial Setup

1. **Configure environment variables:**
   ```bash
   # Copy the example environment file
   cp .env.example .env
   
   # Edit .env to customize settings (optional)
   # Default values work out of the box
   ```

2. **Start the environment:**
   ```bash
   make setup
   ```

2. **Run all examples:**
   ```bash
   make run
   ```

3. **Run individual examples:**
   ```bash
   make example-sql      # SQL ETL procedure
   make example-dbt      # dbt transformation
   make example-airflow  # Airflow DAG info
   ```

4. **Access services:**
   - PostgreSQL: `localhost:5432` (configured via `.env`)
   - Airflow UI: http://localhost:8080 (credentials in `.env`)

5. **Clean up:**
   ```bash
   make down   # Stop services
   make clean  # Remove all data
   ```

### Configuration

All environment variables are stored in the `.env` file. Key configurations:

- **PostgreSQL**: `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`, `POSTGRES_PORT`
- **Airflow**: `_AIRFLOW_WWW_USER_USERNAME`, `_AIRFLOW_WWW_USER_PASSWORD`, `AIRFLOW_PORT`
- **dbt**: `DBT_PROFILES_DIR`, `DBT_PROJECT_DIR`
- **Docker Images**: Version control for all services

To customize, edit `.env` before running `make setup`. The `.env.example` file shows all available options.

### What's Included

- **PostgreSQL database** with sample data
- **dbt environment** for data transformations
- **Airflow** for workflow orchestration
- **Working examples** that actually execute

---

## Table of Contents

- [Introduction](#introduction)
- [Historical Context](#historical-context)
- [Databases and Analytics Engineering](#databases-and-their-impact-on-analytics-engineering)
- [Cloud Computing](#cloud-computing-and-its-impact-on-analytics-engineering)
- [The Data Analytics Lifecycle](#the-data-analytics-lifecycle)
- [The Analytics Engineer Role](#the-new-role-of-analytics-engineer)
- [Data Mesh and Data Products](#enabling-analytics-in-a-data-mesh)
- [Data Transformation](#the-heart-of-analytics-engineering)
- [Legacy ETL Processes](#the-legacy-processes)
- [The dbt Revolution](#the-dbt-revolution)
- [Summary](#summary)

---

## Introduction

Analytics engineering combines analytical thinking with software engineering practices to transform raw data into actionable insights. It's not just about building data pipelines or creating visualizations—it's about applying rigorous problem-solving to understand business challenges and deliver reliable, well-tested data products.

**Key principle:** Start by identifying your organization's knowledge gaps and business objectives before selecting tools or building pipelines. Let the complexity of the problem guide your solution.

### Why This Topic Matters

Data modeling—including approaches like Kimball, conceptual, logical, and physical modeling—remains foundational to effective analytics, even as tools evolve. Analytics engineering represents a natural progression from traditional business intelligence, combining proven methodologies with modern tools for more efficient implementation.

### Who Should Read This

- Data professionals transitioning to analytics engineering
- Analysts learning modern data transformation tools
- Organizations building or improving their data infrastructure

### Book Overview

| Chapter | Topic | Focus |
|---------|-------|-------|
| 1 | Analytics Engineering | Evolution, roles, and concepts |
| 2 | Data Modeling | Structuring data for analysis |
| 3 | SQL for Analytics | Views, window functions, CTEs |
| 4 | dbt Fundamentals | Project structure, testing, documentation |
| 5 | dbt Advanced | Materializations, Jinja, macros, semantic layer |
| 6 | End-to-End Use Case | Complete analytics workflow |

---

## Historical Context

### Data Warehousing Origins (1980s-1990s)

- **Bill Inmon** established the theoretical foundation for data warehousing
- **Ralph Kimball** introduced dimensional modeling in *The Data Warehouse Toolkit* (1996)

### Big Data Era (2000s)

Google and Amazon's scale requirements led to:
- Google File System
- Apache Hadoop
- The rise of "Big Data Engineering"

### Cloud Revolution (2012+)

- **Amazon Redshift** (2012): Blended OLAP with traditional database technology
- **Google BigQuery** and **Snowflake**: Streamlined administration with advanced processing
- The modern data stack emerged: Apache Airflow, dbt, Looker

### The Modern Data Engineer

Today's data engineers handle:
- Data modeling and quality assurance
- Security and data management
- Architectural design and orchestration
- Software engineering practices (CI/CD, version control)

Primary languages: **Python** and **SQL**, with Java, Scala, and Go for specific use cases.

---

## Databases and Their Impact on Analytics Engineering

### The Challenge

The proliferation of data tools has created a fragmented landscape requiring continuous learning. Organizations must balance:
- Tool selection across analysis, visualization, and storage
- Agile methodologies and cross-functional collaboration
- Specialized skills in data science and BI
- Growing data volume, variety, and velocity

### Databases: The Foundation

**Database:** An organized collection of structured data stored electronically, accessible through predefined rules (schema).

Databases enable analytics by:
- Efficiently storing and retrieving large datasets
- Ensuring data integrity and consistency
- Supporting complex analyses

### Key Database Applications

| Application | Description |
|-------------|-------------|
| **Data Warehousing** | Centralized store integrating data from multiple sources into a consistent model (star schema, Data Vault) |
| **Data Mining** | Statistical and ML techniques to uncover patterns and predict behavior |

### Why Analytics Engineering?

Connecting BI tools directly to operational databases (OLTP) works for small datasets but creates bottlenecks at scale. Analytics engineers:
- Optimize data workflows
- Transform and aggregate data for analytical tasks
- Design pipelines from sources to optimized warehouses/lakes
- Bridge the gap between raw data and actionable insights

---

## Cloud Computing and Its Impact on Analytics Engineering

### The Shift to Cloud

Business pressures have driven adoption of managed and serverless offerings, reducing reliance on dedicated support staff. Organizations prioritize:
- Ease of use and lower latency
- Improved security
- Real-time capabilities
- Faster time to market

### Data Analytics vs. Business Intelligence

| Term | Scope |
|------|-------|
| **Business Intelligence** | Business-oriented decision making |
| **Data Analytics** | Broader spectrum including product, operational, and specialized analytics |

### Cloud vs. On-Premises

**On-premises challenges:**
- High upfront costs (hardware, software, maintenance)
- Limited flexibility and scalability
- Significant specialist staffing requirements

**Cloud advantages:**
- Accelerated deployment
- Reduced infrastructure costs
- Elastic scalability

### Major Cloud Data Platforms

- **Microsoft Fabric**: Comprehensive analytics platform
- **dbt**: Open source, deployable on-premises or integrated with Azure, GCP, AWS
- **BigQuery, Snowflake, Redshift**: Cloud-native data warehouses

### Cloud Risks to Manage

| Risk | Description |
|------|-------------|
| Data privacy | Compliance verification challenges |
| Vendor lock-in | Limited migration flexibility |
| Security | Concentrated data attracts attacks |
| Cost complexity | Difficult ROI measurement |

**Mitigation:** Develop a comprehensive data strategy covering cloud approach, technology, processes, people, and governance.

### Cloud + AI Synergy

Cloud data platforms accelerate:
- Analytics-driven architecture adoption
- AI initiative operationalization
- Enterprise-wide insights
- Data modernization

---

## The Data Analytics Lifecycle

The data analytics lifecycle transforms raw data into valuable products: datasets, dashboards, reports, APIs, or applications.

### Why Structure Matters

Different stakeholders need the same data for different purposes:
- **Executives:** High-level KPIs
- **Managers:** Granular operational reports

A governed, standardized approach ensures consistent data products from a shared foundation.

### Lifecycle Stages

```
┌─────────────────┐
│ 1. Problem      │
│    Definition   │
└────────┬────────┘
         ▼
┌─────────────────┐
│ 2. Data         │
│    Modeling     │
└────────┬────────┘
         ▼
┌─────────────────┐
│ 3. Ingestion &  │
│    Transform    │
└────────┬────────┘
         ▼
┌─────────────────┐
│ 4. Storage &    │
│    Structuring  │
└────────┬────────┘
         ▼
┌─────────────────┐
│ 5. Visualization│
│    & Analysis   │
└────────┬────────┘
         ▼
┌─────────────────┐
│ 6. Quality,     │
│    Testing,Docs │
└─────────────────┘
```

#### 1. Problem Definition
Identify business objectives, available data, and required resources.

#### 2. Data Modeling
Choose the appropriate technique: star schema, Data Vault, diamond strategy, or denormalized approach. (See Chapter 2)

#### 3. Data Ingestion and Transformation
- **Schema-on-write:** Transform raw data directly into models
- **Schema-on-read:** Minimal transformation at ingestion, heavy transformation downstream

#### 4. Data Storage and Structuring
Decisions include:
- File formats: Parquet, Delta Lake, Apache Iceberg
- Partitioning strategies
- Storage platform: S3, Redshift, BigQuery, Snowflake

#### 5. Data Visualization and Analysis
Create dashboards and reports in coordination with business stakeholders.

#### 6. Data Quality, Testing, and Documentation
End-to-end concern: implement quality controls, document transformations, and test pipelines continuously.

> **Note:** dbt enables parallel development of documentation, testing, and quality controls across the lifecycle. See Chapter 4.

---

## The New Role of Analytics Engineer

### Position in the Data Team

The analytics engineer bridges **data platform engineers** (infrastructure) and **data analysts** (insights):

| Role | Analogy | Focus |
|------|---------|-------|
| Data Platform Engineer | Foundation builder | Plumbing, electrical, structure |
| Analytics Engineer | Architect | Design aligned with business needs |
| Data Analyst | Interior designer | User-friendly, tailored content |

### Core Responsibilities

Analytics engineers create well-tested, documented datasets that enable self-service analytics across the organization.

**Technical responsibilities:**
- Design and implement data storage/retrieval systems
- Create and maintain data pipelines (ETL/ELT)
- Ensure data accuracy, completeness, and accessibility
- Optimize performance for volume and complexity

**Collaboration:**
- Work with data scientists on ML model requirements
- Support proper training data pipelines
- Monitor model performance metrics

**Skills required:**
- Programming: Python, SQL, Spark
- Cloud platforms: AWS, GCP, Azure
- Software engineering practices: version control, CI/CD
- Business communication

### The ETL → ELT Shift

The move from schema-on-write (ETL) to schema-on-read (ELT) means data lands in repositories before transformation. This creates opportunity for technical analysts who understand both business context and data modeling—the analytics engineer.

---

## Enabling Analytics in a Data Mesh

### What is Data Mesh?

A modern architectural framework where business domain teams own their data and access services, rather than relying solely on a central data team.

**Benefits:**
- Finer scaling and more autonomy
- Better data management
- Flexibility for different data types
- Culture of experimentation and collaboration

### Analytics Engineer's Role in Data Mesh

- Build and maintain independent, autonomous data services
- Create shared, well-documented data models
- Ensure data discoverability, accessibility, and security
- Implement governance: access controls, lineage, quality checks
- Ensure regulatory compliance

### Data Products

Accessible applications providing data-driven insights for decision-making or automation.

**Examples:**
- REST APIs for querying business data models
- Data pipelines ingesting from multiple sources
- Data lakes for structured/unstructured data
- Visualization tools for communicating insights

### dbt as a Data Mesh Enabler

| Feature | Capability |
|---------|------------|
| Data Modeling | SQL-based syntax for defining/testing models |
| Testing | Framework for validating accuracy and reliability |
| Documentation | Self-documenting models and services |
| Lineage | Track data origin and flow |
| Governance | Enforce access controls and quality checks |

> **Note:** Many successful dbt deployments start with simple star schema models and adopt data mesh concepts as needs evolve.

---

## The Heart of Analytics Engineering

### Data Transformation

The process of converting data from one format/structure to another, making it useful for specific applications.

**Examples:**
- Cleaning and preparing data
- Aggregating and summarizing
- Enriching with additional information

### ETL vs. ELT

| Strategy | Process | Best For |
|----------|---------|----------|
| **ETL** | Extract → Transform → Load | Traditional, schema-on-write |
| **ELT** | Extract → Load → Transform | Modern, flexible, cloud-native |

**ELT advantages:**
- Greater flexibility
- Support for diverse data applications
- Real-time insights within target system
- Adapts to changing analytical needs

**ELT trade-off:** Higher storage and ingestion costs, often justified by flexibility gains.

> dbt is the "gemba" (where value is created) for analysts—transforming and delivering data in usable form.

---

## The Legacy Processes

### Traditional ETL Challenges

- Complex, time-consuming
- Required specialized skills
- Manual coding, error-prone
- Difficult to scale
- Inflexible to changing needs

### SQL and Stored Procedures

Legacy ETL often used stored procedures in RDBMS (SQL Server, Oracle):



**Limitations:**
- Requires specialized knowledge
- Lacks flexibility and scalability
- Difficult to integrate with other systems
- Hard to troubleshoot

### ETL Tools (e.g., Apache Airflow)

Airflow is an open source platform for managing and scheduling data pipelines using Python.



**Airflow limitations:**
- Complex to set up for large pipelines
- Not designed specifically for data transformation
- May require additional tools for data manipulation

---

## The dbt Revolution

### What dbt Provides

dbt (data build tool) simplifies data transformation and modeling:


### Key Benefits

| Benefit | Description |
|---------|-------------|
| Reusable code | Maintainable, testable transformations |
| Simple syntax | High-level language eliminating SQL complexity |
| Team collaboration | Version control, shared standards |
| Pipeline integration | Works with Airflow, Dagster, Prefect, dbt Cloud |

### dbt + Orchestration

Integrating dbt with Airflow provides:
- Scheduled dbt runs
- Automated pipeline management
- Data refresh on new data or updated logic
- CI/CD-like practices for data

> dbt addresses Airflow's transformation limitations while Airflow handles scheduling and orchestration.

---

## Summary

### Key Takeaways

**Evolution:** Data management has progressed from SQL stored procedures to flexible workflows using tools like Airflow and dbt.

**The Analytics Engineer:** Bridges data engineering and analytics, ensuring reliable insights through:
- Software engineering practices
- Business understanding
- Technical implementation skills

**Core Challenges Remain:**
- Acquiring critical data
- Maintaining data quality
- Efficient storage
- Meeting stakeholder expectations

**Data Modeling is Central:** Efficient modeling structures and organizes data to reflect real-world relationships—covered in Chapter 2.

### Topics Covered

- Evolution of data management
- The analytics engineer role
- Data mesh concepts
- ETL vs. ELT strategies
- dbt as transformation tool

---

*Next: [Chapter 2 - Data Modeling for Analytics](../c02-Data%20Modeling%20for%20Analytics/readme.md)*

# Analytics Engineering Examples - Quick Reference

## Setup

```bash
# Start all services
make setup

# This will:
# - Start PostgreSQL with sample data
# - Start dbt container
# - Start Airflow web server
```

## Running Examples

### Run Everything
```bash
make run
```

### Individual Examples

**SQL ETL Procedure**
```bash
make example-sql
```
- Demonstrates Extract, Transform, Load pattern
- Reads from `source_table`
- Transforms data (uppercase text, multiply numbers)
- Loads into `target_table`

**dbt Data Transformation**
```bash
make example-dbt
```
- Runs dbt model to calculate total revenue
- Creates `total_revenue` table
- Shows dbt compilation and execution

**Airflow DAG**
```bash
make example-airflow
```
- Shows Airflow DAG configuration
- Visit http://localhost:8080 to see the UI
- Login: admin / admin

## Database Access

**Connection Details:**
- Host: localhost
- Port: 5432
- Database: analytics_db
- User: analytics
- Password: analytics

**Connect with psql:**
```bash
docker compose exec postgres psql -U analytics -d analytics_db
```

**Useful Queries:**
```sql
-- View source data
SELECT * FROM source_table;

-- View transformed data
SELECT * FROM target_table;

-- View dbt model output
SELECT * FROM total_revenue;

-- View orders data
SELECT * FROM orders;
```

## Services

**Airflow UI:** http://localhost:8080
- Username: admin
- Password: admin
- View DAGs, task execution, logs

**PostgreSQL:** localhost:5432
- Direct database access
- Run SQL queries
- View transformed data

## Cleanup

```bash
# Stop services (keep data)
make down

# Stop services and remove all data
make clean
```

## Troubleshooting

**Check service status:**
```bash
docker compose ps
```

**View logs:**
```bash
# All services
make logs

# Specific service
docker compose logs postgres
docker compose logs dbt
docker compose logs airflow-standalone
```

**Restart a service:**
```bash
docker compose restart postgres
docker compose restart dbt
docker compose restart airflow-standalone
```

**Full reset:**
```bash
make clean
make setup
```

## What's Happening

### Example 1-1: SQL ETL
1. Extracts data from `source_table`
2. Transforms: uppercase text, doubles numbers
3. Loads into `target_table`
4. Classic ETL pattern in SQL

### Example 1-3: dbt Model
1. dbt compiles the model
2. Queries `orders` table
3. Calculates sum of revenue
4. Creates `total_revenue` table
5. Modern ELT pattern - transform after load

### Example 1-2: Airflow
1. DAG defines workflow
2. Two tasks: print_date → sleep
3. Shows dependency management
4. Orchestrates data pipelines
