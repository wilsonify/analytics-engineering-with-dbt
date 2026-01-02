-- Singular Test: assert_source_total_payment_amount_is_positive.sql
-- Validates source payment data has no negative amounts per order

select
    orderid as order_id,
    sum(amount) as total_amount
from {{ source('stripe', 'payment') }}
group by 1
having total_amount < 0
