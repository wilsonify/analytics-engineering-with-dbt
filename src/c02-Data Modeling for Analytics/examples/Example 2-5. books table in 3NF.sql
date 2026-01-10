CREATE TABLE authors (

author_id INT PRIMARY KEY,

author_name VARCHAR(100)

);

CREATE TABLE books (

book_id INT PRIMARY KEY,

title VARCHAR(100),

);

CREATE TABLE genres (

genre_id INT PRIMARY KEY,

genre_name VARCHAR(50)

);

CREATE TABLE bookDetails (

book_id INT PRIMARY KEY,

author_id INT,

genre_id INT,

publication_year INT,

FOREIGN KEY (author_id) REFERENCES authors(author_id), FOREIGN KEY (genre_id) REFERENCES genres(genre_id)

);