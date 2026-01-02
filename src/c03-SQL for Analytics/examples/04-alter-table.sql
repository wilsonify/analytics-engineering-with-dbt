-- Example 3-4: ALTER TABLE - Add Column
ALTER TABLE books
ADD COLUMN isbn VARCHAR(20);

-- Example 3-5: ALTER TABLE - Modify Column
ALTER TABLE books
MODIFY COLUMN price DECIMAL(10, 2);

-- Example 3-6: ALTER TABLE - Drop Column
ALTER TABLE books
DROP COLUMN isbn;
