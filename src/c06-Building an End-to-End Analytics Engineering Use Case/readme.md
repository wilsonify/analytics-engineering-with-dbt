# Chapter 6: Building an End-to-End Analytics Engineering Use Case

## Table of Contents
- [Problem Definition](#problem-definition)
- [Operational Data Modeling](#operational-data-modeling)
- [High-Level Data Architecture](#high-level-data-architecture)
- [Analytical Data Modeling](#analytical-data-modeling)
- [Creating the Data Warehouse with dbt](#creating-the-data-warehouse-with-dbt)
- [Tests, Documentation, and Deployment](#tests-documentation-and-deployment)
- [Data Analytics with SQL](#data-analytics-with-sql)
- [Conclusion](#conclusion)

---

## Problem Definition

**Use Case:** Omnichannel Analytics - Enhance customer experience across multiple channels (website, mobile app, customer support).

### Required Data

| Category | Data Points |
|----------|-------------|
| **Customer Info** | Name, email, phone, demographics |
| **Interactions** | Channel visits, touchpoints, engagement |
| **Orders** | Order date, amount, payment method |
| **Products** | Name, category, price |

**Objectives:**
- Understand customer preferences across channels
- Identify cross-sell/upsell opportunities
- Optimize omnichannel strategy
- Drive business growth

---

## Operational Data Modeling

### Three-Step Modeling Process

```
┌─────────────────────────────────────────────────────────────┐
│          Operational Database Design Process                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Conceptual Model  ──▶  Logical Model  ──▶  Physical Model │
│   (Entities & ERD)     (Tables & Keys)     (MySQL DDL)     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 1. Conceptual Model

**Entities:**
- Customer
- Product
- Channel

**Relationships:**
- Buy (Customer → Product via Channel)
- Visit (Customer → Channel)

### 2. Logical Model

Converts conceptual entities to tables:

| Table | Type | Purpose |
|-------|------|---------|
| `customers` | Entity | Customer details |
| `products` | Entity | Product catalog |
| `channels` | Entity | Available channels |
| `purchaseHistory` | Relationship | Buy relationship (M:N) |
| `visitHistory` | Relationship | Visit relationship (M:N) |

### 3. Physical Model (MySQL)

**Primary Tables:**

→ See [examples/operational/01-create-database.sql](examples/operational/01-create-database.sql)
→ See [examples/operational/02-create-tables.sql](examples/operational/02-create-tables.sql)

**Relationship Tables:**

→ See [examples/operational/03-create-relationships.sql](examples/operational/03-create-relationships.sql)

**Key Features:**
- Auto-increment primary keys
- `CREATED_AT` / `UPDATED_AT` audit columns (for CDC)
- Foreign key constraints (referential integrity)
- Default values (e.g., `discount` defaults to 0)

---

## High-Level Data Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                     Data Flow Architecture                       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│   MySQL (Source)          BigQuery (Target)                      │
│   ┌─────────────┐         ┌──────────────┐                      │
│   │ Operational │         │ Raw Dataset  │                      │
│   │   Tables    │ ──ETL──▶│omnichannel_  │                      │
│   │             │ Python  │    raw       │                      │
│   └─────────────┘         └──────────────┘                      │
│                                  │                               │
│                                  │ dbt                           │
│                                  ▼                               │
│                           ┌──────────────┐                      │
│                           │ Analytics    │                      │
│                           │  Dataset     │                      │
│                           │omnichannel_  │                      │
│                           │  analytics   │                      │
│                           └──────────────┘                      │
│                                  │                               │
│                                  ▼                               │
│                           ┌──────────────┐                      │
│                           │ SQL Analysis │                      │
│                           └──────────────┘                      │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### ETL Pipeline (Python)

**Components:**
1. **Extract** - Query MySQL tables
2. **Transform** - Clean data types (dates to strings)
3. **Load** - Write to BigQuery using `pandas_gbq`

→ See [examples/etl/01-mysql-to-bigquery-pipeline.py](examples/etl/01-mysql-to-bigquery-pipeline.py)
→ See [examples/etl/02-extract-function.py](examples/etl/02-extract-function.py)
→ See [examples/etl/03-transform-function.py](examples/etl/03-transform-function.py)
→ See [examples/etl/04-load-function.py](examples/etl/04-load-function.py)
→ See [examples/etl/05-run-pipeline.py](examples/etl/05-run-pipeline.py)

**Key Features:**
- Automatic table discovery via `information_schema`
- Dynamic extraction loop
- Error handling and connection management

---

## Analytical Data Modeling

### Four-Step Process

| Step | Description |
|------|-------------|
| 1. **Identify Business Processes** | Sales tracking, website performance |
| 2. **Identify Facts & Dimensions** | Define measures and context |
| 3. **Identify Attributes** | Detailed dimension properties |
| 4. **Define Granularity** | Transaction-level vs. aggregated |

### Business Processes

1. **Sales Tracking** - Revenue across channels
2. **Website Performance** - Visits and bounce rates per channel

### Star Schema Design

```
┌──────────────────────────────────────────────────────────────┐
│                        Star Schema                           │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│              dim_date          dim_channels                  │
│                  │                   │                       │
│                  └──────┬────────────┘                       │
│                         │                                    │
│         dim_customers ──┼── fct_purchase_history            │
│                         │                                    │
│                  ┌──────┴────────┐                          │
│                  │               │                           │
│            dim_products    fct_visit_history                │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Dimensions

| Dimension | Key Attributes | Purpose |
|-----------|----------------|---------|
| `dim_channels` | sk_channel, nk_channel_id, dsc_channel_name | Channel context |
| `dim_customers` | sk_customer, nk_customer_id, dsc_name, dsc_email_address | Customer details |
| `dim_products` | sk_product, nk_product_sku, dsc_product_name, mtr_unit_price | Product catalog |
| `dim_date` | date_day, month, quarter, year | Time analysis |

**Note:** `dim_channels`, `dim_customers`, and `dim_date` are **conformed dimensions** (shared across facts).

### Facts

| Fact | Grain | Key Measures |
|------|-------|--------------|
| `fct_purchase_history` | Transaction-level | mtr_quantity, mtr_discount, mtr_total_amount_gross, mtr_total_amount_net |
| `fct_visit_history` | Visit-level | mtr_length_of_stay_minutes |

### Naming Conventions

| Prefix | Type | Description |
|--------|------|-------------|
| `stg_` | Table/CTE | Staging layer |
| `dim_` | Table | Dimension |
| `fct_` | Table | Fact |
| `sk_` | Column | Surrogate key |
| `nk_` | Column | Natural key (from source) |
| `mtr_` | Column | Metric (numeric) |
| `dsc_` | Column | Description (text) |
| `dt_` | Column | Date/time |

---

## Creating the Data Warehouse with dbt

### Project Structure

```
models/
├── staging/
│   ├── _omnichannel_raw_sources.yml
│   ├── _omnichannel_raw_models.yml
│   ├── stg_channels.sql
│   ├── stg_customers.sql
│   ├── stg_products.sql
│   ├── stg_purchase_history.sql
│   └── stg_visit_history.sql
└── marts/
    ├── _omnichannel_marts.yml
    ├── dim_channels.sql
    ├── dim_customers.sql
    ├── dim_products.sql
    ├── dim_date.sql
    ├── fct_purchase_history.sql
    └── fct_visit_history.sql
```

### Staging Layer

**Source Configuration:**

→ See [examples/dbt/staging/01-sources.yml](examples/dbt/staging/01-sources.yml)

**Staging Models:**

→ See [examples/dbt/staging/02-stg_channels.sql](examples/dbt/staging/02-stg_channels.sql)
→ See [examples/dbt/staging/03-stg_customers.sql](examples/dbt/staging/03-stg_customers.sql)
→ See [examples/dbt/staging/04-stg_products.sql](examples/dbt/staging/04-stg_products.sql)
→ See [examples/dbt/staging/05-stg_purchase_history.sql](examples/dbt/staging/05-stg_purchase_history.sql)
→ See [examples/dbt/staging/06-stg_visit_history.sql](examples/dbt/staging/06-stg_visit_history.sql)

**Models Configuration:**

→ See [examples/dbt/staging/07-models.yml](examples/dbt/staging/07-models.yml)

### Marts Layer - Dimensions

**Surrogate Key Generation:**
```sql
{{ dbt_utils.generate_surrogate_key(["nk_channel_id"]) }} AS sk_channel
```

→ See [examples/dbt/marts/01-dim_channels.sql](examples/dbt/marts/01-dim_channels.sql)
→ See [examples/dbt/marts/02-dim_customers.sql](examples/dbt/marts/02-dim_customers.sql)
→ See [examples/dbt/marts/03-dim_products.sql](examples/dbt/marts/03-dim_products.sql)
→ See [examples/dbt/marts/04-dim_date.sql](examples/dbt/marts/04-dim_date.sql)

### Marts Layer - Facts

**Purchase History:**
- Joins with dimensions to get surrogate keys
- Calculates gross and net amounts

→ See [examples/dbt/marts/05-fct_purchase_history.sql](examples/dbt/marts/05-fct_purchase_history.sql)

**Visit History:**
- Tracks customer visits and bounce rates
- Calculates length of stay

→ See [examples/dbt/marts/06-fct_visit_history.sql](examples/dbt/marts/06-fct_visit_history.sql)

### Required Packages

→ See [examples/dbt/packages.yml](examples/dbt/packages.yml)

```bash
dbt deps  # Install packages
dbt build # Build all models
```

---

## Tests, Documentation, and Deployment

### Testing Strategy

```
┌────────────────────────────────────────────────────────┐
│                   Testing Pyramid                      │
├────────────────────────────────────────────────────────┤
│                                                        │
│              Singular Tests                            │
│           (Business Logic Validation)                  │
│         ┌─────────────────────────┐                   │
│         │ • Positive amounts      │                    │
│         │ • Price logic           │                    │
│         │ • Stay duration         │                    │
│         └─────────────────────────┘                   │
│                     ▲                                  │
│                     │                                  │
│              Generic Tests                             │
│         (Data Quality Checks)                          │
│    ┌─────────────────────────────────┐               │
│    │ • Unique/not null keys          │                │
│    │ • Referential integrity         │                │
│    └─────────────────────────────────┘               │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### Generic Tests

**Dimension Key Tests:**
- `unique` - No duplicate keys
- `not_null` - Keys always populated

**Fact Relationship Tests:**
- `relationships` - Foreign keys exist in dimensions

→ See [examples/dbt/marts/07-marts-tests.yml](examples/dbt/marts/07-marts-tests.yml)

```bash
dbt test  # Run all tests
```

### Singular Tests

| Test | Purpose | File |
|------|---------|------|
| Positive total amount | Ensure no negative sales | [01-assert-total-amount-positive.sql](examples/dbt/tests/01-assert-total-amount-positive.sql) |
| Unit price logic | Unit price ≤ total gross | [02-assert-unit-price-logic.sql](examples/dbt/tests/02-assert-unit-price-logic.sql) |
| Positive stay duration | No negative visit lengths | [03-assert-length-of-stay-positive.sql](examples/dbt/tests/03-assert-length-of-stay-positive.sql) |

```bash
dbt test --select test_type:singular  # Run only singular tests
```

### Documentation

→ See [examples/dbt/marts/08-marts-documented.yml](examples/dbt/marts/08-marts-documented.yml)

```bash
dbt docs generate  # Generate documentation
```

### Deployment

**Environment Setup:**
1. Create production environment in dbt Cloud
2. Set target dataset: `omnichannel_analytics`
3. Configure job with commands:
   - `dbt build`
   - `dbt test`
4. Enable "Generate docs on run"

---

## Data Analytics with SQL

### Example Queries

**1. Total Amount per Quarter with Discount**

→ See [examples/analytics/01-total-amount-per-quarter.sql](examples/analytics/01-total-amount-per-quarter.sql)

**2. Average Time Spent per Channel**

→ See [examples/analytics/02-avg-time-per-channel.sql](examples/analytics/02-avg-time-per-channel.sql)

**3. Top Three Products per Channel (Window Functions)**

→ See [examples/analytics/03-top-products-per-channel.sql](examples/analytics/03-top-products-per-channel.sql)

**4. Top Three Customers in 2023 on Mobile App**

→ See [examples/analytics/04-top-customers-mobile-app.sql](examples/analytics/04-top-customers-mobile-app.sql)

### SQL Techniques Demonstrated

| Technique | Purpose |
|-----------|---------|
| **Star Schema Joins** | Simple, efficient dimension lookups |
| **CTEs** | Structured, readable query organization |
| **Window Functions** | Rankings and partitioned aggregations |
| **Aggregations** | Sum, average, round calculations |

### Benefits of Star Schema

| Benefit | Description |
|---------|-------------|
| **Simplicity** | Easy-to-understand model |
| **Performance** | Optimized for analytical queries |
| **Flexibility** | Mix and match dimensions/facts |
| **Reusability** | Conformed dimensions across facts |

---

## Conclusion

### Key Takeaways

This chapter demonstrated the **complete analytics engineering lifecycle**:

```
┌──────────────────────────────────────────────────────────────┐
│              Analytics Engineering Journey                   │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Problem     Operational    Data         Analytical         │
│  Definition  ──▶ Modeling  ──▶ Pipeline  ──▶ Modeling      │
│                                                              │
│                     │                                        │
│                     ▼                                        │
│                                                              │
│  dbt         Tests &        SQL                             │
│  Implementation ──▶ Docs   ──▶ Analytics                   │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Topics Integrated

| Topic | Application |
|-------|-------------|
| **Data Modeling** | Conceptual → Logical → Physical → Dimensional |
| **SQL** | DDL, DML, CTEs, window functions, aggregations |
| **dbt** | Sources, staging, dimensions, facts, tests, docs |
| **Best Practices** | Naming conventions, audit columns, referential integrity |

### Example Files Summary

```
examples/
├── operational/           # MySQL operational database
│   ├── 01-create-database.sql
│   ├── 02-create-tables.sql
│   └── 03-create-relationships.sql
├── etl/                  # Python ETL pipeline
│   ├── 01-mysql-to-bigquery-pipeline.py
│   ├── 02-extract-function.py
│   ├── 03-transform-function.py
│   ├── 04-load-function.py
│   └── 05-run-pipeline.py
├── dbt/
│   ├── packages.yml
│   ├── staging/          # 7 files (sources, models, configs)
│   ├── marts/            # 8 files (dimensions, facts, tests, docs)
│   └── tests/            # 3 singular tests
└── analytics/            # 4 SQL analysis queries
```

### The Analytics Engineer's Toolkit

Like **Iron Man's armor** provides tools for every challenge, analytics engineers leverage:

- **Databases** - Foundation and reliability
- **SQL** - Precision and flexibility
- **dbt** - Collaboration and automation
- **Data Modeling** - Structure and meaning

Just as **Sherlock Holmes** weaves stories from fragmentary evidence, analytics engineers create compelling data models from fragmented data points, uncovering secrets hidden in complex datasets.

---

## Further Reading

- [Kimball's Dimensional Modeling](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/)
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
- [Star Schema Design](https://www.ibm.com/topics/star-schema)
