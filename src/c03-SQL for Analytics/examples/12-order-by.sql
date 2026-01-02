-- Example 3-26: ORDER BY
SELECT * FROM books ORDER BY publication_year ASC;
SELECT * FROM books ORDER BY price DESC;

-- Example 3-27: Multiple Column Sorting
SELECT * FROM books ORDER BY author_id ASC, publication_year DESC;
