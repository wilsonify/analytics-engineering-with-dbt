-- Example 2-10: Star schema location dimension
-- This demonstrates a denormalized dimension table in a star schema

DROP TABLE IF EXISTS dim_location_star CASCADE;

CREATE TABLE dim_location_star (
    location_id INT PRIMARY KEY,
    country VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50)
);

-- Insert sample data
INSERT INTO dim_location_star (location_id, country, state, city) VALUES
    (1, 'USA', 'California', 'San Francisco'),
    (2, 'USA', 'California', 'Los Angeles'),
    (3, 'USA', 'New York', 'New York City'),
    (4, 'USA', 'Texas', 'Austin'),
    (5, 'Canada', 'Ontario', 'Toronto');

SELECT 'Star schema dimension created' AS status;
SELECT * FROM dim_location_star;