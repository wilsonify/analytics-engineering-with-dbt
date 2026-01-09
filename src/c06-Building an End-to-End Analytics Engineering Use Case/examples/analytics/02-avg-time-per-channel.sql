-- Example 6-30: Analytics Query - Average Time Spent per Channel

SELECT 
    dc.dsc_channel_name,
    ROUND(AVG(mtr_length_of_stay_minutes), 2) as avg_length_of_stay_minutes
FROM `omnichannel_analytics.fct_visit_history` fct
LEFT JOIN `omnichannel_analytics.dim_channels` dc
    on fct.sk_channel = dc.sk_channel
GROUP BY dc.dsc_channel_name
