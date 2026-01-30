-- Example 6-25: Singular Test - Positive Total Amount
-- assert_mtr_total_amount_gross_is_positive.sql

select
    sk_customer,
    sk_channel,
    sk_product,
    sum(mtr_total_amount_gross) as mtr_total_amount_gross
from {{ ref('fct_purchase_history') }}
group by 1, 2, 3
having sum(mtr_total_amount_gross) < 0
