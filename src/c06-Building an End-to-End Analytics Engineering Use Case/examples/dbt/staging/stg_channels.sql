-- Example 6-11: Staging Model - Channels

with raw_channels AS (
    SELECT
        channel_id,
        channel_name,
        CREATED_AT,
        UPDATED_AT
    FROM {{ source("omnichannel","channels")}}
)

SELECT *
FROM raw_channels
