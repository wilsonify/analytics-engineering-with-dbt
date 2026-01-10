CREATE TABLE satBooks (

bookKey INT,

loadDate DATETIME,

author VARCHAR(100),

publicationYear INT,

genre VARCHAR(50),

PRIMARY KEY (bookKey, loaddate),

FOREIGN KEY (bookKey) REFERENCES hubBooks(bookKey)

);