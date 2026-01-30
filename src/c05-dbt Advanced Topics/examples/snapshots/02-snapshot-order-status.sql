-- Example 5-5: Snapshot for SCD Type 2
-- Tracks historical changes with valid_from/valid_to dates

{% snapshot snap_order_status_transition %}

{{
    config(
        target_schema='snapshots',
        unique_key='id',
        strategy='check',
        check_cols=['status'],
    )
}}

select * from {{ ref('orders') }}

{% endsnapshot %}
