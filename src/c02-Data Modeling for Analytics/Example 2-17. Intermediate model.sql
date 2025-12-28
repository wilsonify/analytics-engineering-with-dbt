-- This should be file int_book_authors.sql

-- Reference the staging models

WITH

books AS (

SELECT *

FROM {{ ref('stg_books') }}

),

authors AS (

SELECT *

FROM {{ ref('stg_authors') }}

)

-- Combine the relevant information

SELECT

b.book_id,

b.title,

a.author_id,

a.author_name

FROM

books b

JOIN

authors a ON b.author_id = a.author_id
