-- Example 6-26: Singular Test - Unit Price Logic
-- assert_mtr_unit_price_is_equal_or_lower_than_mtr_total_amount_gross.sql

select
    sk_customer,
    sk_channel,
    sk_product,
    sum(mtr_total_amount_gross) AS mtr_total_amount_gross,
    sum(mtr_unit_price) AS mtr_unit_price
from {{ ref('fct_purchase_history') }}
group by 1, 2, 3
having sum(mtr_unit_price) > sum(mtr_total_amount_gross)
