-- Example 6-32: Analytics Query - Top Three Customers in 2023 on Mobile App

WITH base_cte AS (
    SELECT 
        dcu.dsc_name,
        dcu.dsc_email_address,
        dc.dsc_channel_name,
        ROUND(SUM(fct.mtr_total_amount_net), 2) as sum_total_amount
    FROM `omnichannel_analytics`.`fct_purchase_history` fct
    LEFT JOIN `omnichannel_analytics`.`dim_customers` dcu
        on dcu.sk_customer = fct.sk_customer
    LEFT JOIN `omnichannel_analytics`.`dim_channels` dc
        on dc.sk_channel = fct.sk_channel
    WHERE dc.dsc_channel_name = 'Mobile App'
    GROUP BY dc.dsc_channel_name, dcu.dsc_name, dcu.dsc_email_address
    ORDER BY sum_total_amount DESC
)

SELECT *
FROM base_cte
LIMIT 3
