-- Table Authors

CREATE TABLE authors (

author_id INT PRIMARY KEY,

author_name VARCHAR(100)

);

-- Table Books

CREATE TABLE books (

book_id INT PRIMARY KEY,

title VARCHAR(100),

publication_year INT,

genre VARCHAR(50),

author_id INT,

FOREIGN KEY (author_id) REFERENCES authors(author_id)

);