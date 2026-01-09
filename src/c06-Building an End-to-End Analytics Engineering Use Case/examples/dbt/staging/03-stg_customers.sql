-- Example 6-12: Staging Model - Customers

with raw_customers AS (
    SELECT
        customer_id,
        name,
        date_birth,
        email_address,
        phone_number,
        country,
        CREATED_AT,
        UPDATED_AT
    FROM {{ source("omnichannel","Customers")}}
)

SELECT *
FROM raw_customers
