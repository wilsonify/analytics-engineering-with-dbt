-- Example 6-31: Analytics Query - Top Three Products per Channel

WITH base_cte AS (
    SELECT 
        dp.dsc_product_name,
        dc.dsc_channel_name,
        ROUND(SUM(fct.mtr_total_amount_net), 2) as sum_total_amount
    FROM {{ ref("fct_purchase_history") }} fct
    LEFT JOIN {{ ref("dim_products") }} dp
        on dp.sk_product = fct.sk_product
    LEFT JOIN {{ ref("dim_channels") }} dc
        on dc.sk_channel = fct.sk_channel
    GROUP BY dc.dsc_channel_name, dp.dsc_product_name
),

ranked_cte AS (
    SELECT 
        base_cte.dsc_product_name,
        base_cte.dsc_channel_name,
        base_cte.sum_total_amount,
        RANK() OVER(PARTITION BY dsc_channel_name ORDER BY sum_total_amount DESC) AS rank_total_amount
    FROM base_cte
)

SELECT *
FROM ranked_cte
WHERE rank_total_amount <= 3
