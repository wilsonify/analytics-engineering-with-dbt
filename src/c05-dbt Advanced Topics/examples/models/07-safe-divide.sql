-- Example 5-21: dbt_utils safe_divide Macro
-- Handles division by zero gracefully (returns null instead of error)

select
    order_id,
    customer_id,
    cash_amount,
    total_amount,
    {{ dbt_utils.safe_divide('cash_amount', 'total_amount') }} as cash_percentage
from {{ ref('fct_orders') }}
