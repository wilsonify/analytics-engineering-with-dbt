-- This should be file mart_book_authors.sql

{{

config(

materialized='table',

unique_key='author_id',

sort='author_id'

)

}}

WITH book_counts AS (

SELECT

author_id,

COUNT(*) AS total_books

FROM {{ ref('int_book_authors') }}

GROUP BY author_id

)

SELECT

author_id,

total_books

FROM book_counts