-- Staging Models: stg_jaffle_shop_customers.sql
-- Transforms raw customer data from Jaffle Shop

select
    id as customer_id,
    first_name,
    last_name
from {{ source('jaffle_shop', 'customers') }}
