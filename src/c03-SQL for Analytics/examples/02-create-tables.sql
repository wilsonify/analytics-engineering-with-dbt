-- Example 3-2: Creating Tables with Primary and Foreign Keys

-- Authors table
CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_year INT
);

-- Books table with foreign key reference
CREATE TABLE books (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(255),
    publication_year INT,
    price DECIMAL(5, 2),
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);
