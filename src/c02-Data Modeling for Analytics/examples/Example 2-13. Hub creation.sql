-- Example 2-13: Hub creation
-- This demonstrates creating a Hub table in Data Vault 2.0

DROP TABLE IF EXISTS hub_books CASCADE;

CREATE TABLE hub_books (
    book_key SERIAL PRIMARY KEY,
    book_hash_key VARCHAR(64) UNIQUE NOT NULL,
    title VARCHAR(100),
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(50) DEFAULT 'books_source'
);

-- Insert sample data (deriving hash keys from business keys)
INSERT INTO hub_books (book_hash_key, title) VALUES
    (MD5('1'), 'Data Modeling Essentials'),
    (MD5('2'), 'Advanced SQL'),
    (MD5('3'), 'Analytics Engineering'),
    (MD5('4'), 'Database Design');

SELECT 'Hub table created' AS status;
SELECT * FROM hub_books;
