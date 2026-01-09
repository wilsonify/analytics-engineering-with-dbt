-- Example 5-11: Static Payment Types Macro
-- Returns a hardcoded list of payment types

{% macro get_payment_types() %}
    {{ return(['cash', 'credit', 'debit', 'gift_card']) }}
{% endmacro %}
