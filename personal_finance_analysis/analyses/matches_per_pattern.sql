-- How many transactions match each pattern?

with patterns as (
    select
        regex_id,
        regex_pattern,
        description,
        priority,
        place_id
    from {{ ref('slv_description_patterns') }}

),

matches as (
    select
        regex_id,
        count(transaction_id) as n
    from {{ ref('slv_description_matches') }}
    group by regex_id
)

select
    patterns.regex_id,
    patterns.regex_pattern,
    patterns.description,
    patterns.priority,
    patterns.place_id,
    coalesce(matches.n, 0) as number_of_matches
from patterns
left join matches
    on patterns.regex_id = matches.regex_id
order by number_of_matches asc
