-- Example 5-5: Snapshot for SCD Type 2
-- Tracks historical changes with valid_from/valid_to dates

{% snapshot snap_order_status_transition %}

{{
    config(
        target_database='analytics',
        target_schema='snapshots',
        unique_key='order_id',
        strategy='check',
        check_cols=['status'],
    )
}}

select * from {{ source('jaffle_shop', 'orders') }}

{% endsnapshot %}
