-- Singular Test: assert_total_payment_amount_is_positive.sql
-- Validates that no order has negative total amount

select
    order_id,
    sum(total_amount) as total_amount
from {{ ref('int_payment_type_amount_per_order') }}
group by 1
having sum(total_amount) < 0
