with source as (
    select
        tr.source_id,
        sr.bank_name,
        sr.source_type,
        tr.place_id,
        tr.category_id,
        tr.type_id
    from {{ ref('slv_fact_transactions') }} as tr
    inner join {{ ref('slv_dim_sources') }} as sr
        on tr.source_id = sr.source_id
    {# join {{ ref('source_dimension') }} as sr on tr.source_id = sr.source_id
    join {{ ref('place_dimension') }} as pl on tr.place_id = pl.place_id
    join {{ ref('category_dimension') }} as cat on tr.category_id = cat.category_id #}
)

select
    bank_name,
    source_type,

    count(bank_name) as number_of_transactions,
    count(distinct source_id) as number_of_sources,

    -- places
    sum(if(place_id != -1, 0, 1)) as missing_places,
    round(sum(if(place_id != -1, 0, 1)) / count(place_id), 2)
        as percentage_missing_places,

    -- categories
    sum(if(category_id != -1, 0, 1)) as missing_categories,
    round(sum(if(category_id != -1, 0, 1)) / count(category_id), 2)
        as percentage_missing_categories,

    -- types
    sum(if(type_id != -1, 0, 1)) as missing_types,
    round(sum(if(type_id != -1, 0, 1)) / count(type_id), 2)
        as percentage_missing_types
from source
group by bank_name, source_type
