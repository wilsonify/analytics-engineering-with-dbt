-- Example 3-9: CONSTRAINT (UNIQUE)
ALTER TABLE books
ADD CONSTRAINT unique_book_title UNIQUE (book_title);

-- Example 3-10: CONSTRAINT (CHECK)
ALTER TABLE books
ADD CONSTRAINT check_publication_year CHECK (publication_year >= 1800);
