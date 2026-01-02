-- Example 3-13: INSERT Statement
INSERT INTO authors (author_id, first_name, last_name, birth_year)
VALUES (1, 'Stephen', 'King', 1947);

-- Example 3-14: INSERT Multiple Rows
INSERT INTO books (book_id, book_title, publication_year, price, author_id)
VALUES 
    (1, 'The Shining', 1977, 19.99, 1),
    (2, 'It', 1986, 24.99, 1),
    (3, 'Carrie', 1974, 14.99, 1);
