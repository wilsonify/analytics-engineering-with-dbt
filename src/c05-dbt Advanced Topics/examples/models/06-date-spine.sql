-- Example 5-20: dbt_utils date_spine Macro
-- Generates a series of dates between start and end

{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2023-01-01' as date)",
    end_date="cast('2023-02-01' as date)"
) }}

-- Output: One row per day from 2023-01-01 to 2023-01-31
