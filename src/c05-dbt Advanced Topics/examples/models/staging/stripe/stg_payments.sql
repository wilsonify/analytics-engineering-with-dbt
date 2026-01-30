-- Staging model: stg_payments
select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    case
        when paymentmethod in ('stripe', 'paypal', 'credit_card', 'gift_card')
        then 'credit'
        else 'cash'
    end as payment_type,
    status,
    amount,
    created as created_date
from {{ ref('payment') }}
