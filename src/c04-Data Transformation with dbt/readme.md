# Chapter 4: Data Transformation with dbt

## Table of Contents

- [Overview](#overview)
- [dbt Design Philosophy](#dbt-design-philosophy)
- [dbt Data Flow](#dbt-data-flow)
- [dbt Cloud Setup](#dbt-cloud-setup)
- [Project Structure](#project-structure)
- [YAML Configuration](#yaml-configuration)
- [Models](#models)
  - [Model Layers](#model-layers)
  - [ref() Function](#ref-function)
- [Sources](#sources)
  - [source() Function](#source-function)
  - [Source Freshness](#source-freshness)
- [Tests](#tests)
  - [Generic Tests](#generic-tests)
  - [Singular Tests](#singular-tests)
- [Analyses](#analyses)
- [Seeds](#seeds)
- [Documentation](#documentation)
- [Commands & Selection Syntax](#commands--selection-syntax)
- [Jobs & Deployment](#jobs--deployment)
- [Summary](#summary)
- [Examples](#examples)

---

## Overview

dbt (data build tool) transforms data in your data platform using SQL SELECT statements. It brings software engineering best practices to analytics:

- Version control and collaboration
- Testing and documentation
- Automated deployment
- Modularity and reusability (DRY code)

```
┌─────────────────────────────────────────────────────────────────┐
│                      ELT Pipeline with dbt                      │
├─────────────────────────────────────────────────────────────────┤
│  Extract → Load → ┌─────────────────────────────┐ → Serve       │
│                   │         TRANSFORM           │               │
│                   │  • Models (SQL SELECT)      │               │
│                   │  • Tests (data validation)  │               │
│                   │  • Documentation            │               │
│                   │  • Version Control (Git)    │               │
│                   └─────────────────────────────┘               │
│                              dbt                                │
└─────────────────────────────────────────────────────────────────┘
```

---

## dbt Design Philosophy

| Principle | Description |
|-----------|-------------|
| **Code-Centric** | Define transformations in code, not GUIs |
| **Modularity** | Create reusable models, macros, packages |
| **SQL SELECT** | Models are SELECT statements |
| **Declarative** | Specify outcomes, dbt handles implementation |
| **Incremental Builds** | Update only changed data |
| **Docs as Code** | Documentation lives with code |
| **Testing Built-In** | Define data quality checks |
| **Version Control** | Git integration for collaboration |
| **Platform Native** | Works with BigQuery, Snowflake, Redshift, Databricks |

---

## dbt Data Flow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Sources    │────►│     dbt      │────►│   Models     │
│  (Raw Data)  │     │  Transform   │     │ (Tables/Views)│
└──────────────┘     └──────────────┘     └──────────────┘
       │                    │                    │
       ▼                    ▼                    ▼
  BigQuery             SQL + Jinja          Data Warehouse
  Snowflake            Testing              Documentation
  Redshift             Documentation        Lineage
```

**Two deployment options:**
- **dbt Cloud**: Managed service with IDE, scheduling, CI/CD
- **dbt Core**: Open source CLI for self-managed environments

---

## dbt Cloud Setup

### BigQuery Connection
1. Create GCP project
2. Create service account with BigQuery Admin role
3. Generate JSON keyfile
4. Upload keyfile to dbt Cloud

### GitHub Integration
1. Create repository
2. Connect GitHub account to dbt Cloud
3. Initialize dbt project

### Key Git Practices

| Practice | Description |
|----------|-------------|
| Commit often | Small, logical changes |
| Meaningful messages | Explain what and why |
| Use branches | Feature branches for development |
| Pull before push | Reduce merge conflicts |
| Use .gitignore | Exclude build artifacts |

---

## Project Structure

```
root/
├─ analyses/          # Ad-hoc queries (not materialized)
├─ dbt_packages/      # Installed packages
├─ logs/              # Execution logs
├─ macros/            # Reusable Jinja code (functions)
├─ models/            # SQL SELECT transformations ⭐
│  ├─ staging/        # Clean raw data
│  ├─ intermediate/   # Complex transformations
│  └─ marts/          # Business-ready tables
├─ seeds/             # Static CSV lookup tables
├─ snapshots/         # SCD Type 2 history tracking
├─ target/            # Compiled SQL output
├─ tests/             # Singular test files
├─ dbt_project.yml    # Project configuration ⭐
├─ packages.yml       # Package dependencies
└─ profiles.yml       # Connection config (CLI only)
```

📁 **Example:** [dbt_project.yml](examples/dbt_project.yml) | [packages.yml](examples/packages.yml) | [profiles.yml](examples/profiles.yml)

---

## YAML Configuration

YAML files configure models, sources, tests, and documentation.

### Organization Best Practices

```
models/staging/jaffle_shop/
├─ _jaffle_shop_sources.yml   # Source definitions
├─ _jaffle_shop_models.yml    # Model configs & tests
├─ _jaffle_shop_docs.md       # Documentation blocks
├─ stg_jaffle_shop_customers.sql
└─ stg_jaffle_shop_orders.sql
```

### Cascading Configuration

Configurations cascade from `dbt_project.yml` → folder YAML → model file:

```yaml
# dbt_project.yml (default)
models:
  my_project:
    staging:
      +materialized: view    # All staging = views

# _models.yml (override)
models:
  - name: stg_special_model
    config:
      materialized: table    # This specific model = table
```

---

## Models

Models are SQL SELECT statements that transform data into tables or views.

### Model Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                       Model Layers                              │
├─────────────────────────────────────────────────────────────────┤
│  STAGING          │  INTERMEDIATE      │  MARTS               │
│  ────────────     │  ─────────────     │  ──────              │
│  • Clean raw data │  • Complex logic   │  • Business tables   │
│  • Rename columns │  • Aggregations    │  • Facts & Dims      │
│  • Type casting   │  • Multi-source    │  • Domain-specific   │
│  • 1:1 with source│    joins           │                      │
│                   │                    │                      │
│  stg_*            │  int_*             │  fct_*, dim_*        │
└─────────────────────────────────────────────────────────────────┘
```

| Layer | Purpose | Materialization | Naming |
|-------|---------|-----------------|--------|
| **Staging** | Clean raw data, rename columns | View | `stg_{source}_{table}` |
| **Intermediate** | Complex transformations, aggregations | View | `int_{description}` |
| **Marts** | Business-ready facts and dimensions | Table | `fct_{entity}`, `dim_{entity}` |

### ref() Function

Reference other models to build dependencies and lineage:

```sql
-- Creates dependency and enables lineage tracking
select * from {{ ref('stg_jaffle_shop_orders') }}
```

📁 **Examples:** 
- Staging: [stg_jaffle_shop_customers.sql](examples/models/staging/jaffle_shop/stg_jaffle_shop_customers.sql) | [stg_jaffle_shop_orders.sql](examples/models/staging/jaffle_shop/stg_jaffle_shop_orders.sql) | [stg_stripe_order_payments.sql](examples/models/staging/stripe/stg_stripe_order_payments.sql)
- Intermediate: [int_payment_type_amount_per_order.sql](examples/models/intermediate/int_payment_type_amount_per_order.sql)
- Marts: [dim_customers.sql](examples/models/marts/core/dim_customers.sql) | [fct_orders.sql](examples/models/marts/core/fct_orders.sql)

---

## Sources

Sources define raw data tables in your data platform.

### source() Function

```sql
-- Reference raw data with source()
select * from {{ source('jaffle_shop', 'customers') }}
```

Benefits:
- Centralized source definitions
- Easy to update if raw data moves
- Appears in lineage graphs
- Enables source freshness testing

📁 **Examples:** [_jaffle_shop_sources.yml](examples/models/staging/jaffle_shop/_jaffle_shop_sources.yml) | [_stripe_sources.yml](examples/models/staging/stripe/_stripe_sources.yml)

### Source Freshness

Monitor data staleness:

```yaml
sources:
  - name: jaffle_shop
    tables:
      - name: orders
        loaded_at_field: _etl_loaded_at
        freshness:
          warn_after: {count: 12, period: hour}
          error_after: {count: 24, period: hour}
```

Run: `dbt source freshness`

---

## Tests

Tests are assertions about your data. dbt returns rows that **fail** the test.

### Generic Tests

Built-in tests applied via YAML:

| Test | Purpose |
|------|---------|
| `unique` | Every value is unique |
| `not_null` | No null values |
| `accepted_values` | Values in predefined list |
| `relationships` | Foreign key integrity |

```yaml
models:
  - name: stg_orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
      - name: status
        tests:
          - accepted_values:
              values: [completed, shipped, returned, placed]
      - name: customer_id
        tests:
          - relationships:
              to: ref('stg_customers')
              field: customer_id
```

📁 **Example:** [_jaffle_shop_models.yml](examples/models/staging/jaffle_shop/_jaffle_shop_models.yml)

### Singular Tests

Custom SQL tests in the `tests/` folder (return rows = failures):

```sql
-- tests/assert_positive_amounts.sql
select order_id, total_amount
from {{ ref('int_payment_type_amount_per_order') }}
where total_amount < 0
```

📁 **Examples:** [assert_total_payment_amount_is_positive.sql](examples/tests/assert_total_payment_amount_is_positive.sql) | [assert_source_total_payment_amount_is_positive.sql](examples/tests/assert_source_total_payment_amount_is_positive.sql)

---

## Analyses

Ad-hoc queries that use Jinja but don't materialize as tables:

- Audit queries
- Training/refactoring queries
- Version-controlled SQL

📁 **Examples:** [most_valuable_customers.sql](examples/analyses/most_valuable_customers.sql) | [customer_range_based_on_total_paid_amount.sql](examples/analyses/customer_range_based_on_total_paid_amount.sql)

---

## Seeds

CSV files materialized as tables for static lookup data:

```csv
min_range,max_range,classification
0,9.999,Regular
10,29.999,Bronze
30,49.999,Silver
50,9999999,Gold
```

```sql
-- Reference with ref()
select * from {{ ref('seed_customer_range') }}
```

Run: `dbt seed`

📁 **Example:** [seed_customer_range_per_paid_amount.csv](examples/seeds/seed_customer_range_per_paid_amount.csv)

---

## Documentation

Documentation is generated from YAML descriptions and doc blocks:

### YAML Descriptions

```yaml
models:
  - name: fct_orders
    description: Analytical orders data.
    columns:
      - name: order_id
        description: Primary key of orders.
```

### Doc Blocks (Markdown)

```markdown
{% docs is_order_completed %}
Binary indicator of order completion.

| Value | Meaning |
|-------|---------|
| 0 | Not completed |
| 1 | Completed |
{% enddocs %}
```

Reference in YAML: `description: "{{ doc('is_order_completed') }}"`

Generate: `dbt docs generate`

📁 **Examples:** [_core_models.yml](examples/models/marts/core/_core_models.yml) | [_core_docs.md](examples/models/marts/core/_core_docs.md)

---

## Commands & Selection Syntax

### Essential Commands

| Command | Purpose |
|---------|---------|
| `dbt run` | Execute model transformations |
| `dbt test` | Run data tests |
| `dbt build` | Run + test + snapshot |
| `dbt docs generate` | Generate documentation |
| `dbt seed` | Load CSV seeds |
| `dbt source freshness` | Check source staleness |
| `dbt deps` | Install packages |
| `dbt compile` | Compile Jinja to SQL |
| `dbt clean` | Remove build artifacts |

### Selection Syntax

```bash
# Run specific model
dbt run --select fct_orders

# Run model and its dependencies
dbt run --select +fct_orders      # upstream
dbt run --select fct_orders+      # downstream
dbt run --select +fct_orders+     # both

# Run by tag
dbt run --select tag:marketing

# Run by folder
dbt run --select models/marts/core/*

# Test specific source
dbt test --select source:jaffle_shop

# Exclude models
dbt run --exclude stg_*
```

---

## Jobs & Deployment

### Environment Types

| Environment | Purpose |
|-------------|---------|
| **Development** | Build and test changes |
| **Deployment/Production** | Serve business users |

### Job Configuration

1. **Environment**: Link to deployment environment
2. **Commands**: `dbt build`, `dbt test`, etc.
3. **Triggers**: Schedule, webhook, or API
4. **Settings**: Generate docs, check source freshness

### Deployment Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Development │────►│ Pull Request│────►│ Production  │
│   Branch    │     │   Review    │     │   Branch    │
└─────────────┘     └─────────────┘     └─────────────┘
       │                                       │
       ▼                                       ▼
   Dev Schema                            Prod Schema
   (dbt_dev)                          (dbt_prod)
```

---

## Summary

| Component | Purpose | Key Files |
|-----------|---------|-----------|
| **Models** | SQL transformations | `.sql` in `models/` |
| **Sources** | Raw data definitions | `_sources.yml` |
| **Tests** | Data validation | `_models.yml`, `tests/*.sql` |
| **Seeds** | Static lookup data | `seeds/*.csv` |
| **Analyses** | Ad-hoc queries | `analyses/*.sql` |
| **Documentation** | Model/column descriptions | `.yml`, `.md` |
| **Macros** | Reusable Jinja code | `macros/*.sql` |
| **Snapshots** | SCD Type 2 history | `snapshots/*.sql` |

**Key Takeaways:**
1. dbt transforms data using SQL SELECT statements
2. Organize models into staging → intermediate → marts layers
3. Use `ref()` and `source()` for dependencies and lineage
4. Test data quality with generic and singular tests
5. Document as you build using YAML descriptions
6. Deploy via jobs with scheduling and CI/CD

---

## Examples

All examples are in the [examples/](examples/) directory:

### Configuration Files
| File | Description |
|------|-------------|
| [dbt_project.yml](examples/dbt_project.yml) | Project configuration |
| [packages.yml](examples/packages.yml) | Package dependencies |
| [profiles.yml](examples/profiles.yml) | Connection config (CLI) |

### Models
| File | Layer |
|------|-------|
| [stg_jaffle_shop_customers.sql](examples/models/staging/jaffle_shop/stg_jaffle_shop_customers.sql) | Staging |
| [stg_jaffle_shop_orders.sql](examples/models/staging/jaffle_shop/stg_jaffle_shop_orders.sql) | Staging |
| [stg_stripe_order_payments.sql](examples/models/staging/stripe/stg_stripe_order_payments.sql) | Staging |
| [int_payment_type_amount_per_order.sql](examples/models/intermediate/int_payment_type_amount_per_order.sql) | Intermediate |
| [dim_customers.sql](examples/models/marts/core/dim_customers.sql) | Marts |
| [fct_orders.sql](examples/models/marts/core/fct_orders.sql) | Marts |

### YAML Configurations
| File | Purpose |
|------|---------|
| [_jaffle_shop_sources.yml](examples/models/staging/jaffle_shop/_jaffle_shop_sources.yml) | Source definitions |
| [_jaffle_shop_models.yml](examples/models/staging/jaffle_shop/_jaffle_shop_models.yml) | Model tests |
| [_stripe_sources.yml](examples/models/staging/stripe/_stripe_sources.yml) | Source definitions |
| [_core_models.yml](examples/models/marts/core/_core_models.yml) | Documentation |
| [_core_docs.md](examples/models/marts/core/_core_docs.md) | Doc blocks |

### Tests & Analyses
| File | Type |
|------|------|
| [assert_total_payment_amount_is_positive.sql](examples/tests/assert_total_payment_amount_is_positive.sql) | Singular test |
| [assert_source_total_payment_amount_is_positive.sql](examples/tests/assert_source_total_payment_amount_is_positive.sql) | Singular test |
| [most_valuable_customers.sql](examples/analyses/most_valuable_customers.sql) | Analysis |
| [customer_range_based_on_total_paid_amount.sql](examples/analyses/customer_range_based_on_total_paid_amount.sql) | Analysis |

### Seeds
| File | Purpose |
|------|---------|
| [seed_customer_range_per_paid_amount.csv](examples/seeds/seed_customer_range_per_paid_amount.csv) | Customer classification ranges |

---

[← Chapter 3: SQL for Analytics](../c03-SQL%20for%20Analytics/readme.md) | [Chapter 5: dbt Advanced Topics →](../c05-dbt%20Advanced%20Topics/readme.md)
