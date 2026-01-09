-- Example 5-6: Jinja Target Environment
-- Conditional logic based on deployment target

select
    order_id,
    customer_id,
    order_date
from {{ ref('stg_orders') }}

{% if target.name == 'dev' %}
    -- Limit data in development
    where order_date >= current_date - interval '30 days'
{% endif %}
