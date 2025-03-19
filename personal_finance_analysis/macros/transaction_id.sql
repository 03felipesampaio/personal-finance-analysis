{% macro generate_transaction_id(
    transaction_date, source_id, description_id, amount) %}
    
    abs(
        farm_fingerprint(
            concat(
                {{ transaction_date }}, 
                {{ source_id }},
                {{ description_id }},
                {{ amount }},

                row_number() over (partition by transaction_date, source_id, description_id, amount)
            )
        )
    )

{% endmacro %}
