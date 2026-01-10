-- Example 2-22: Documentation
-- This demonstrates documenting a model with comments explaining calculations
-- In dbt, this would be in a YAML file, but here we show SQL with extensive comments

DROP TABLE IF EXISTS nps_metrics CASCADE;
DROP TABLE IF EXISTS demo_customer_feedback CASCADE;
DROP TABLE IF EXISTS demo_customer CASCADE;

/* 
 * NPS Metrics Model
 * 
 * Description:
 * This model calculates the Net Promoter Score (NPS) for our product
 * based on customer feedback.
 * 
 * Dependencies:
 * - demo_customer_feedback: stores customer feedback ratings
 * - demo_customer: contains customer information
 * 
 * Calculation:
 * The NPS is calculated by categorizing customers as:
 * - Promoters: Customers with ratings of 9 or 10
 * - Passives: Customers with ratings of 7 or 8
 * - Detractors: Customers with ratings of 0 to 6
 * 
 * The NPS is derived by subtracting the percentage of Detractors 
 * from the percentage of Promoters.
 */

-- Create demo tables
CREATE TABLE demo_customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE demo_customer_feedback (
    feedback_id SERIAL PRIMARY KEY,
    customer_id INT,
    feedback_rating INT CHECK (feedback_rating BETWEEN 0 AND 10),
    FOREIGN KEY (customer_id) REFERENCES demo_customer(customer_id)
);

-- Insert sample data
INSERT INTO demo_customer (customer_id, customer_name) VALUES
    (1, 'John Smith'),
    (2, 'Jane Doe'),
    (3, 'Bob Johnson'),
    (4, 'Alice Brown'),
    (5, 'Charlie Wilson');

INSERT INTO demo_customer_feedback (customer_id, feedback_rating) VALUES
    (1, 9),  -- Promoter
    (2, 10), -- Promoter
    (3, 7),  -- Passive
    (4, 5),  -- Detractor
    (5, 8);  -- Passive

-- Create NPS metrics table
CREATE TABLE nps_metrics AS
WITH feedback_summary AS (
    SELECT
        CASE
            WHEN feedback_rating >= 9 THEN 'Promoter'
            WHEN feedback_rating >= 7 THEN 'Passive'
            ELSE 'Detractor'
        END AS feedback_category
    FROM
        demo_customer_feedback cf
    JOIN
        demo_customer c
    ON cf.customer_id = c.customer_id
)
SELECT
    COUNT(*) FILTER (WHERE feedback_category = 'Promoter') AS promoters,
    COUNT(*) FILTER (WHERE feedback_category = 'Passive') AS passives,
    COUNT(*) FILTER (WHERE feedback_category = 'Detractor') AS detractors,
    (COUNT(*) FILTER (WHERE feedback_category = 'Promoter')::FLOAT / COUNT(*) * 100 -
     COUNT(*) FILTER (WHERE feedback_category = 'Detractor')::FLOAT / COUNT(*) * 100) AS nps_score
FROM
    feedback_summary;

SELECT 'Documentation example created' AS status;
SELECT * FROM nps_metrics;