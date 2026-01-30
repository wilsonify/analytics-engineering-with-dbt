-- Staging model: stg_orders
select
    id as order_id,
    user_id as customer_id,
    order_date,
    status,
    _etl_loaded_at,
    _etl_loaded_at as updated_at
from {{ ref('orders') }}
