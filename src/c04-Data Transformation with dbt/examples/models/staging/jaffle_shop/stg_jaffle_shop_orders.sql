-- Staging Models: stg_jaffle_shop_orders.sql
-- Transforms raw order data from Jaffle Shop

select
    id as order_id,
    user_id as customer_id,
    order_date,
    status,
    _etl_loaded_at
from {{ ref('orders') }}
