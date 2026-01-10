-- In the orders.sql file

SELECT

o.order_id,

o.order_date,

o.order_amount,

c.customer_name,

c.customer_email

FROM

{{ ref('orders') }} AS o

JOIN

{{ ref('customers') }} AS c

ON

o.customer_id = c.customer_id

-- In the customers.sql file

-- customers.sql

SELECT

customer_id,

customer_name,

customer_email

FROM

raw_customers