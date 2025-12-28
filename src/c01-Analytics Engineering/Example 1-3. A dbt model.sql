{{ config(materialized='table') }}

select
    sum(orders.revenue) as total_revenue
from {{ ref('orders') }} as orders