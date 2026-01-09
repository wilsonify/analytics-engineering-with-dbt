# Chapter 5: dbt Advanced Topics

## Table of Contents
- [Model Materializations](#model-materializations)
- [Snapshots](#snapshots)
- [Dynamic SQL with Jinja](#dynamic-sql-with-jinja)
- [SQL Macros](#sql-macros)
- [dbt Packages](#dbt-packages)
- [dbt Semantic Layer](#dbt-semantic-layer)
- [Summary](#summary)

---

## Model Materializations

Materializations control **how dbt builds models** in your data warehouse.

### Materialization Types

| Type | Storage | Rebuild | Use Case |
|------|---------|---------|----------|
| **View** | Virtual | Every query | Light transformations, always-fresh data |
| **Table** | Physical | Full refresh | Heavy transformations, stable source data |
| **Ephemeral** | None (CTE) | Inline | Intermediate logic, no direct queries |
| **Incremental** | Physical | Append/merge | Large tables, event data |
| **Materialized View** | Physical | Auto-refresh | Pre-computed aggregations |

### Configuration Methods

```yaml
# dbt_project.yml (project-wide)
models:
  my_project:
    staging:
      +materialized: view
    marts:
      +materialized: table
```

```sql
-- Model file (per-model)
{{ config(materialized='incremental') }}
```

### Incremental Models

Process only new/changed data instead of full table rebuilds:

```
┌─────────────────────────────────────────────────┐
│             Incremental Strategy                │
├─────────────────────────────────────────────────┤
│  First Run:  SELECT * FROM source              │
│  Next Runs:  SELECT * FROM source              │
│              WHERE updated_at > last_run       │
│              MERGE INTO existing_table         │
└─────────────────────────────────────────────────┘
```

**Key Components:**
- `unique_key` - Column(s) for upsert logic
- `is_incremental()` - Jinja function to detect incremental runs
- `{{ this }}` - Reference to current model's existing table

→ See [examples/models/01-incremental-model.sql](examples/models/01-incremental-model.sql)

### Incremental Strategies by Platform

| Strategy | Platforms | Description |
|----------|-----------|-------------|
| `append` | All | Insert new rows only |
| `merge` | BigQuery, Snowflake, Databricks | Upsert based on unique_key |
| `delete+insert` | All | Delete matching rows, then insert |
| `insert_overwrite` | BigQuery, Spark | Replace partitions |

---

## Snapshots

Snapshots implement **Slowly Changing Dimension Type 2 (SCD2)** to track historical changes.

```
┌──────────────────────────────────────────────────────────┐
│                    SCD Type 2 Tracking                   │
├──────────────────────────────────────────────────────────┤
│  order_id │ status    │ dbt_valid_from │ dbt_valid_to   │
│  ─────────┼───────────┼────────────────┼──────────────  │
│  1        │ pending   │ 2024-01-01     │ 2024-01-05     │
│  1        │ shipped   │ 2024-01-05     │ 2024-01-08     │
│  1        │ delivered │ 2024-01-08     │ NULL (current) │
└──────────────────────────────────────────────────────────┘
```

### Snapshot Strategies

| Strategy | Config | Use When |
|----------|--------|----------|
| `timestamp` | `updated_at` column | Source has reliable timestamp |
| `check` | `check_cols` list | No timestamp, watch specific columns |

→ See [examples/models/02-snapshot-order-status.sql](examples/models/02-snapshot-order-status.sql)

### Running Snapshots

```bash
dbt snapshot              # Run all snapshots
dbt snapshot --select snap_orders  # Run specific snapshot
```

---

## Dynamic SQL with Jinja

Jinja enables **programmatic SQL generation** within dbt models.

### Core Syntax

| Syntax | Purpose | Example |
|--------|---------|---------|
| `{{ }}` | Output expression | `{{ ref('model') }}` |
| `{% %}` | Control statement | `{% if condition %}` |
| `{# #}` | Comment | `{# This is hidden #}` |

### Common Patterns

**Conditional Logic:**
```sql
{% if target.name == 'dev' %}
    where created_at > current_date - 30
{% endif %}
```

**Loops:**
```sql
{% for col in ['a', 'b', 'c'] %}
    sum({{ col }}) as total_{{ col }}{% if not loop.last %},{% endif %}
{% endfor %}
```

**Variables:**
```sql
{% set my_list = ['x', 'y', 'z'] %}
{% set my_var = 'value' %}
```

→ See [examples/models/03-jinja-target-env.sql](examples/models/03-jinja-target-env.sql)
→ See [examples/models/04-jinja-dynamic-pivot.sql](examples/models/04-jinja-dynamic-pivot.sql)

### Built-in Jinja Variables

| Variable | Description |
|----------|-------------|
| `target.name` | Current target profile name |
| `target.schema` | Target schema |
| `target.database` | Target database |
| `this` | Current model relation |
| `execute` | True when SQL is being executed |

---

## SQL Macros

Macros are **reusable Jinja functions** stored in the `macros/` directory.

### Macro Structure

```
┌─────────────────────────────────────────────────┐
│  macros/                                        │
│  ├── get_payment_types.sql                      │
│  ├── limit_dataset_if_not_deploy.sql           │
│  └── utils/                                     │
│      └── get_column_values.sql                  │
└─────────────────────────────────────────────────┘
```

### Macro Definition

```sql
{% macro macro_name(arg1, arg2='default') %}
    -- Macro logic here
    {{ return(result) }}
{% endmacro %}
```

### Macro Examples

| Example | Purpose | File |
|---------|---------|------|
| Basic macro | Add two values | [01-sum-two-values.sql](examples/macros/01-sum-two-values.sql) |
| Static list | Return hardcoded values | [02-get-payment-types-static.sql](examples/macros/02-get-payment-types-static.sql) |
| Dynamic query | Query DB for values | [03-get-payment-types-dynamic.sql](examples/macros/03-get-payment-types-dynamic.sql) |
| Generic function | Reusable column getter | [04-get-column-values.sql](examples/macros/04-get-column-values.sql) |
| Environment filter | Dev/prod data limiting | [05-limit-dataset-if-not-deploy.sql](examples/macros/05-limit-dataset-if-not-deploy.sql) |

### Key Macro Functions

| Function | Purpose |
|----------|---------|
| `run_query()` | Execute SQL and return results |
| `return()` | Return value from macro |
| `execute` | Check if in execution phase |
| `log()` | Print debug messages |

### Using Macros in Models

```sql
-- Call macro with arguments
{{ my_macro('arg1', 'arg2') }}

-- Call macro from package
{{ dbt_utils.date_spine(...) }}
```

→ See [examples/models/05-fct-orders-with-macro.sql](examples/models/05-fct-orders-with-macro.sql)

---

## dbt Packages

Packages enable **code sharing and reuse** across dbt projects.

### Package Installation

1. Create/edit `packages.yml`:
```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
```

2. Install packages:
```bash
dbt deps
```

→ See [examples/packages.yml](examples/packages.yml)

### Package Sources

| Source | Syntax |
|--------|--------|
| dbt Hub | `package: owner/name` |
| Git | `git: "https://github.com/..."` |
| Local | `local: /path/to/package` |

### Popular Packages

| Package | Purpose |
|---------|---------|
| `dbt_utils` | Utility macros (date_spine, pivot, safe_divide) |
| `dbt_expectations` | Data quality tests |
| `dbt_date` | Date/time helpers |
| `codegen` | Generate YAML and SQL |
| `audit_helper` | Compare model outputs |

### dbt_utils Examples

**Date Spine** - Generate date series:
```sql
{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2023-01-01' as date)",
    end_date="cast('2023-02-01' as date)"
) }}
```

**Safe Divide** - Handle division by zero:
```sql
{{ dbt_utils.safe_divide('numerator', 'denominator') }}
```

→ See [examples/models/06-date-spine.sql](examples/models/06-date-spine.sql)
→ See [examples/models/07-safe-divide.sql](examples/models/07-safe-divide.sql)

---

## dbt Semantic Layer

The semantic layer provides a **centralized definition of metrics and dimensions**.

### Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     dbt Semantic Layer                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌───────────────┐    ┌───────────────┐    ┌───────────────┐  │
│   │   Entities    │    │  Dimensions   │    │   Measures    │  │
│   │  (Join Keys)  │───▶│  (Groupings)  │───▶│ (Aggregates)  │  │
│   └───────────────┘    └───────────────┘    └───────────────┘  │
│           │                    │                    │           │
│           └────────────────────┼────────────────────┘           │
│                                ▼                                │
│                    ┌───────────────────────┐                    │
│                    │       Metrics         │                    │
│                    │  (Business Measures)  │                    │
│                    └───────────────────────┘                    │
│                                │                                │
│                                ▼                                │
│                    ┌───────────────────────┐                    │
│                    │     MetricFlow        │                    │
│                    │   (Query Engine)      │                    │
│                    └───────────────────────┘                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Core Components

| Component | Purpose | Example |
|-----------|---------|---------|
| **Entities** | Join keys between models | `order_id`, `customer_id` |
| **Dimensions** | Slice/filter attributes | `order_date`, `status` |
| **Measures** | Aggregatable values | `sum(amount)`, `count(*)` |
| **Metrics** | Business definitions | "Total Revenue", "Order Count" |

### Semantic Model Definition

```yaml
semantic_models:
  - name: orders
    model: ref('fct_orders')
    
    entities:
      - name: order_id
        type: primary
      - name: customer_id
        type: foreign
    
    dimensions:
      - name: order_date
        type: time
    
    measures:
      - name: total_amount
        agg: sum
```

→ See [examples/semantic/01-semantic-model.yml](examples/semantic/01-semantic-model.yml)

### Metrics Definition

```yaml
metrics:
  - name: order_total
    type: simple
    type_params:
      measure: total_amount
  
  - name: completed_orders
    type: simple
    type_params:
      measure: order_count
    filter: |
      {{ Dimension('order_id__is_order_completed') }} = true
```

→ See [examples/semantic/02-metrics.yml](examples/semantic/02-metrics.yml)

### Querying Metrics (MetricFlow)

```bash
mf query --metrics order_total
mf query --metrics order_total --group-by order_date
mf query --metrics order_total,order_count --group-by customer_id
```

### Benefits

| Benefit | Description |
|---------|-------------|
| **Consistency** | Single source of truth for business logic |
| **Reusability** | Define once, query anywhere |
| **Governance** | Centralized metric definitions |
| **Self-Service** | Business users query without SQL |

---

## Summary

### Topics Covered

| Topic | Key Concept |
|-------|-------------|
| Materializations | Control how models are stored (view, table, incremental) |
| Snapshots | Track historical changes with SCD Type 2 |
| Jinja | Dynamic SQL generation with templates |
| Macros | Reusable functions for DRY code |
| Packages | Share and import community code |
| Semantic Layer | Centralized metric definitions |

### Example Files

```
examples/
├── packages.yml                    # Package configuration
├── macros/
│   ├── 01-sum-two-values.sql
│   ├── 02-get-payment-types-static.sql
│   ├── 03-get-payment-types-dynamic.sql
│   ├── 04-get-column-values.sql
│   └── 05-limit-dataset-if-not-deploy.sql
├── models/
│   ├── 01-incremental-model.sql
│   ├── 02-snapshot-order-status.sql
│   ├── 03-jinja-target-env.sql
│   ├── 04-jinja-dynamic-pivot.sql
│   ├── 05-fct-orders-with-macro.sql
│   ├── 06-date-spine.sql
│   └── 07-safe-divide.sql
└── semantic/
    ├── 01-semantic-model.yml
    └── 02-metrics.yml
```

### Key Commands

```bash
dbt run                    # Build models
dbt run --full-refresh     # Rebuild incremental models
dbt snapshot               # Run snapshots
dbt deps                   # Install packages
dbt compile                # Preview compiled SQL
mf query --metrics <name>  # Query semantic layer
```

---

## Further Reading

- [dbt Materializations](https://docs.getdbt.com/docs/build/materializations)
- [dbt Snapshots](https://docs.getdbt.com/docs/build/snapshots)
- [Jinja Template Designer](https://jinja.palletsprojects.com/)
- [dbt Packages Hub](https://hub.getdbt.com/)
- [dbt Semantic Layer](https://docs.getdbt.com/docs/build/about-metricflow)
