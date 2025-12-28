CREATE TABLE dimLocation (

locationID INT PRIMARY KEY,

locationName VARCHAR(50),

cityID INT

);

CREATE TABLE dimCity (

cityID INT PRIMARY KEY,

city VARCHAR(50),

stateID INT

);

CREATE TABLE dimState (

stateID INT PRIMARY KEY,

state VARCHAR(50),

countryID INT

);

CREATE TABLE dimCountry (

countryID INT PRIMARY KEY,

country VARCHAR(50),

);