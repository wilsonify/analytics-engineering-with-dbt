-- Table Authors

CREATE TABLE authors (

author_id INT PRIMARY KEY,

author_name VARCHAR(100)

);

-- Table Books

CREATE TABLE books (

book_id INT PRIMARY KEY,

title VARCHAR(100),

);

-- Table book details

CREATE TABLE bookDetails (

book_id INT PRIMARY KEY,

author_id INT,

genre VARCHAR(50),

publication_year INT,

FOREIGN KEY (author_id) REFERENCES authors(author_id)

);