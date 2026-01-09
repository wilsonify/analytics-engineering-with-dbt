-- Example 5-2: Incremental Model
-- Incremental models only process new/changed data

{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

select
    order_id,
    customer_id,
    order_date,
    status,
    updated_at
from {{ ref('stg_orders') }}

{% if is_incremental() %}
    -- Only process rows modified since last run
    where updated_at > (select max(updated_at) from {{ this }})
{% endif %}
