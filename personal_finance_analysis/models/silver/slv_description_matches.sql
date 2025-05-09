{# {{ config(
    materialized='incremental',
    unique_key='regex_id',
    merge_exclude_columns = ['inserted_at']
) }} #}

-- I dont want to match the same regex pattern with 
-- the same transaction more than once
-- Unless the regex row is updated
-- I want to keep the history of the regex patterns matched


with transactions as (
    select
        transaction_id,
        transaction_description
    from {{ ref('stg_transactions_raw') }}
),

patterns as (
    select
        regex_id,
        regex_pattern
    from {{ ref('slv_description_patterns') }}
)

select
    t.transaction_id,
    p.regex_id,

    current_datetime() as inserted_at
from transactions as t
inner join patterns as p
    on regexp_contains(t.transaction_description, p.regex_pattern)
