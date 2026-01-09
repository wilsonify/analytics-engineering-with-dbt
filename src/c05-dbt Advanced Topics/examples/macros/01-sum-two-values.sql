-- Example 5-8: Basic Macro
-- Simple macro that adds two values

{% macro sum_two_values(a, b) %}
    {{ a }} + {{ b }}
{% endmacro %}

-- Usage in a model:
-- select {{ sum_two_values(5, 10) }} as result
