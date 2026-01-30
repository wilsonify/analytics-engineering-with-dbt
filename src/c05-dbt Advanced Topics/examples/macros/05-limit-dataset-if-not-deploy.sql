-- Example 5-16: Environment-Aware Data Limiting Macro
-- Filters data in non-production environments to reduce query overhead

{% macro limit_dataset_if_not_deploy_env(column_name, nbr_months_of_data) %}
    -- Limit data if not in deploy environment
    {% if target.name != 'deploy' %}
        where {{ column_name }} > CURRENT_DATE - INTERVAL '{{ nbr_months_of_data }} months'
    {% endif %}
{% endmacro %}

-- Usage in a model (Example 5-17):
-- select * from {{ ref('stg_orders') }}
-- {{- limit_dataset_if_not_deploy_env('order_date', 3) }}
