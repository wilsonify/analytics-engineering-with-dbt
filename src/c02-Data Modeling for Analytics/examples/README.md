# Chapter 2: Data Modeling for Analytics - Examples

This directory contains SQL examples demonstrating various data modeling concepts from Chapter 2.

## Quick Start

### List all available examples
```bash
make list-examples
```

### Run all SQL examples
```bash
make run-examples
```

### Run a specific example
```bash
make run-example FILE='Example 2-1. The books database in a physical model.sql'
```

## Example Categories

### Physical Data Models
- **Example 2-1**: The books database in a physical model

### Normalization
- **Example 2-2**: books table to be normalized
- **Example 2-3**: books table in 1NF (First Normal Form)
- **Example 2-4**: books table in 2NF (Second Normal Form)
- **Example 2-5**: books table in 3NF (Third Normal Form)

### Dimensional Modeling
- **Example 2-10**: Star schema location dimension
- **Example 2-11**: Snowflake schema location dimension

### Data Vault 2.0
- **Example 2-12**: Modeling the books table with Data Vault 2.0
- **Example 2-13**: Hub creation
- **Example 2-14**: Satellite creation

### dbt Models
- **Example 2-15**: Referencing model
- **Example 2-16**: Staging model
- **Example 2-17**: Intermediate model
- **Example 2-18**: Mart model
- **Example 2-19**: Singular test example (YAML)
- **Example 2-20**: Generic test example (YAML)

### Documentation & Queries
- **Example 2-22**: Documentation
- **Example 2-23**: Running documentation generation
- **Example 2-24**: Complex query 1
- **Example 2-25**: Deconstructing complex query 1

## Notes

- All examples are **fully functional** and can be run sequentially without errors
- Each example uses `DROP TABLE IF EXISTS` to ensure clean execution
- Examples include sample data to demonstrate the concepts
- dbt-specific syntax (like `{{ ref() }}`) has been converted to standard SQL for demonstration
- YAML files are configuration examples and will be displayed when selected, not executed
- Each example demonstrates a specific data modeling concept with working code and results
