CREATE TABLE category (

category_id INT PRIMARY KEY,

category_name VARCHAR(255)

);

CREATE TABLE books (

book_id INT PRIMARY KEY,

ISBN VARCHAR(13),

title VARCHAR(50),

summary VARCHAR(255)

FOREIGN KEY (category_id) REFERENCES category(category_id),

);

CREATE TABLE authors (

author_id INT PRIMARY KEY,

author_name VARCHAR(255),

date_birth DATETIME

);

CREATE TABLE publishes (

book_id INT,

author_id INT,

publish_date DATE,

planned_publish_date DATE

FOREIGN KEY (book_id) REFERENCES books(book_id), FOREIGN KEY (author_id) REFERENCES author(author_id)

);
