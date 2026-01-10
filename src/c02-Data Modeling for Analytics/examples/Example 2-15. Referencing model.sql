-- Example 2-15: Referencing model
-- This demonstrates how models reference other tables/models
-- In dbt, you would use {{ ref('table_name') }}, but here we use direct table references

DROP VIEW IF EXISTS orders_enriched CASCADE;
DROP TABLE IF EXISTS demo_customers CASCADE;
DROP TABLE IF EXISTS demo_orders CASCADE;

-- Create raw tables
CREATE TABLE demo_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100)
);

CREATE TABLE demo_orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    order_amount DECIMAL(10,2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES demo_customers(customer_id)
);

-- Insert sample data
INSERT INTO demo_customers (customer_id, customer_name, customer_email) VALUES
    (1, 'John Smith', 'john@example.com'),
    (2, 'Jane Doe', 'jane@example.com'),
    (3, 'Bob Johnson', 'bob@example.com');

INSERT INTO demo_orders (order_id, order_date, order_amount, customer_id) VALUES
    (101, '2024-01-15', 150.00, 1),
    (102, '2024-01-20', 250.50, 2),
    (103, '2024-01-25', 99.99, 1),
    (104, '2024-02-01', 500.00, 3);

-- Create enriched orders view (equivalent to a dbt model referencing other models)
CREATE VIEW orders_enriched AS
SELECT
    o.order_id,
    o.order_date,
    o.order_amount,
    c.customer_name,
    c.customer_email
FROM
    demo_orders AS o
JOIN
    demo_customers AS c
ON
    o.customer_id = c.customer_id;

SELECT 'Referencing model created' AS status;
SELECT * FROM orders_enriched;