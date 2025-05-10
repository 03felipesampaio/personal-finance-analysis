-- Which transactions don't have a place
-- even after the regex mapping?

with transactions as (
    select
        sources.bank_name,
        sources.source_type,
        descriptions.description,

        count(transactions.transaction_id) as number_of_transactions
    from {{ ref('slv_fact_transactions') }} as transactions
    inner join {{ ref('slv_dim_sources') }} as sources
        on transactions.source_id = sources.source_id
    inner join {{ ref('slv_dim_descriptions') }} as descriptions
        on transactions.description_id = descriptions.description_id
    where transactions.place_id = -1
    group by
        sources.bank_name,
        sources.source_type,
        descriptions.description
)

select *
from transactions
order by
    number_of_transactions desc
