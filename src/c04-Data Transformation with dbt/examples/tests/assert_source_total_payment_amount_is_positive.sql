-- Singular Test: assert_source_total_payment_amount_is_positive.sql
-- Validates source payment data has no negative amounts per order

select
    orderid as order_id,
    sum(amount) as total_amount
from {{ ref('payment') }}
group by 1
having sum(amount) < 0
