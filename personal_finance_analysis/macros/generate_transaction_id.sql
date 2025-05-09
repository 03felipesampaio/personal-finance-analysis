{% macro generate_transaction_id(
    transaction_date, source_id, description, amount) %}
    
    abs(
        farm_fingerprint(
            concat(
                {{ transaction_date }}, 
                {{ source_id }},
                abs(farm_fingerprint({{ description }})),
                {{ amount }},

                row_number() over (partition by {{ transaction_date }}, {{ source_id }}, abs(farm_fingerprint({{ description }})), {{ amount }})
            )
        )
    )

{% endmacro %}
