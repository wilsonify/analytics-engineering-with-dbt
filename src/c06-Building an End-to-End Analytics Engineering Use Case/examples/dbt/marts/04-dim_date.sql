-- Example 6-20: Dimension Model - Date
-- Leverages dbt_date package

{{ dbt_date.get_date_dimension("2022-01-01", "2024-12-31") }}
