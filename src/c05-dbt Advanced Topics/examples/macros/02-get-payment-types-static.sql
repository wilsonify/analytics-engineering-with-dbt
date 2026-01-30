-- Example 5-11: Static Payment Types Macro
-- Returns a hardcoded list of payment types

{% macro get_payment_types_static() %}
    {{ return(['cash', 'credit', 'debit', 'gift_card']) }}
{% endmacro %}
