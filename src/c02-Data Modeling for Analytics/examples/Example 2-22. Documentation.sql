/* nps_metrics.sql

-- This model calculates the Net Promoter Score (NPS)

for our product based on customer feedback.

Dependencies:

- This model relies on the "customer_feedback"

table in the "feedback" schema, which stores customer feedback data.

- It also depends on the "customer" table in the "users"

schema, containing customer information.

Calculation:

-- The NPS is calculated by categorizing customer

feedback from Promoters, Passives, and Detractors

based on their ratings.

-- Promoters: Customers with ratings of 9 or 10.

-- Passives: Customers with ratings of 7 or 8.

-- Detractors: Customers with ratings of 0 to 6.

-- The NPS is then derived by subtracting the percentage

of Detractors from the percentage of Promoters.

*/

-- SQL Query:

WITH feedback_summary AS (

SELECT

CASE

WHEN feedback_rating >= 9 THEN 'Promoter'

WHEN feedback_rating >= 7 THEN 'Passive'

ELSE 'Detractor'

END AS feedback_category

FROM

feedback.customer_feedback

JOIN

users.customer

ON customer_feedback.customer_id = customer.customer_id

)

SELECT

(COUNT(*) FILTER (WHERE feedback_category = 'Promoter')

- COUNT(*) FILTER (WHERE feedback_category = 'Detractor')) AS nps FROM

feedback_summary;