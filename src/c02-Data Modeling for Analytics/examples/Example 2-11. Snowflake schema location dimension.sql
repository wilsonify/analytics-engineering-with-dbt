-- Example 2-11: Snowflake schema location dimension
-- This demonstrates a normalized dimension with multiple levels (snowflake schema)

DROP TABLE IF EXISTS dim_location_snowflake CASCADE;
DROP TABLE IF EXISTS dim_city CASCADE;
DROP TABLE IF EXISTS dim_state CASCADE;
DROP TABLE IF EXISTS dim_country CASCADE;

-- Create country dimension (highest level)
CREATE TABLE dim_country (
    country_id INT PRIMARY KEY,
    country VARCHAR(50)
);

-- Create state dimension
CREATE TABLE dim_state (
    state_id INT PRIMARY KEY,
    state VARCHAR(50),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES dim_country(country_id)
);

-- Create city dimension
CREATE TABLE dim_city (
    city_id INT PRIMARY KEY,
    city VARCHAR(50),
    state_id INT,
    FOREIGN KEY (state_id) REFERENCES dim_state(state_id)
);

-- Create location dimension (lowest level)
CREATE TABLE dim_location_snowflake (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(50),
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES dim_city(city_id)
);

-- Insert sample data
INSERT INTO dim_country (country_id, country) VALUES
    (1, 'USA'),
    (2, 'Canada');

INSERT INTO dim_state (state_id, state, country_id) VALUES
    (1, 'California', 1),
    (2, 'New York', 1),
    (3, 'Texas', 1),
    (4, 'Ontario', 2);

INSERT INTO dim_city (city_id, city, state_id) VALUES
    (1, 'San Francisco', 1),
    (2, 'Los Angeles', 1),
    (3, 'New York City', 2),
    (4, 'Austin', 3),
    (5, 'Toronto', 4);

INSERT INTO dim_location_snowflake (location_id, location_name, city_id) VALUES
    (1, 'Downtown SF', 1),
    (2, 'Hollywood', 2),
    (3, 'Manhattan', 3),
    (4, 'Downtown Austin', 4),
    (5, 'Downtown Toronto', 5);

SELECT 'Snowflake schema dimensions created' AS status;
SELECT l.*, ci.city, s.state, co.country
FROM dim_location_snowflake l
JOIN dim_city ci ON l.city_id = ci.city_id
JOIN dim_state s ON ci.state_id = s.state_id
JOIN dim_country co ON s.country_id = co.country_id;