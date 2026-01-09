-- Example 5-7: Dynamic Pivot with Jinja Loop
-- Dynamically generates columns for each payment type

select
    order_id,
    {% for payment_type in get_payment_types() %}
        sum(case when payment_type = '{{ payment_type }}' then amount end) as {{ payment_type }}_amount
        {% if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('stg_payments') }}
group by 1
