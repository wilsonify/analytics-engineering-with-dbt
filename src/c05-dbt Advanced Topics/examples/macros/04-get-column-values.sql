-- Example 5-15: Generic Column Values Macro
-- Reusable macro for getting distinct values from any column

{# Generic macro: outputs distinct values of the given column #}
{% macro get_column_values(column_name, table_name) %}
    {% set relation_query %}
        select distinct {{ column_name }}
        from {{ table_name }}
        order by 1
    {% endset %}

    {% set results = run_query(relation_query) %}

    {% if execute %}
        {% set results_list = results.columns[0].values() %}
    {% else %}
        {% set results_list = [] %}
    {% endif %}

    {{ return(results_list) }}
{% endmacro %}

{# Macro to get distinct payment_types #}
{% macro get_payment_types() %}
    {{ return(get_column_values('payment_type', ref('stg_stripe_order_payments'))) }}
{% endmacro %}

{# Macro to get distinct payment_methods #}
{% macro get_payment_methods() %}
    {{ return(get_column_values('payment_method', ref('stg_stripe_order_payments'))) }}
{% endmacro %}
