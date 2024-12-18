with bills_raw as (
    select 
        * 
    from {{ ref("stg_bills_inter") }}
),
bills as (
    select
        ABS(FARM_FINGERPRINT(CONCAT(bank_name, source_type, bill_start_date, bill_end_date))) AS source_id,
        bank_name,
        source_type,
        bill_date,
        bill_reference_month,
        bill_value,
        bill_start_date,
        bill_end_date,
        transaction_date,
        coalesce(type_dimension.type_id, -1) as type_id,
        bills_raw.transaction_type,
        ABS(FARM_FINGERPRINT(transaction_description)) description_id,
        transaction_description,
        coalesce(mapping.place_id, -1) as place_id,
        coalesce(bills_raw.transaction_category, place_dimension.category_id, -1) as category_id,
        coin_dimension.coin_id,
        coin_dimension.coin_symbol,
        transaction_value
    from bills_raw
    left join {{ ref("type_dimension") }}
        on bills_raw.transaction_type = type_dimension.type_description
    left join {{ ref("slv_bills_inter_regex_mapping") }} mapping
        on regexp_contains(transaction_description, regex_pattern)
            and mapping.active = true
    left join {{ ref("place_dimension") }} as place_dimension
        on place_dimension.place_id = mapping.place_id
    join {{ ref("coin_dimension") }} on coin_dimension.coin_code = 'BRL'
)
select * from bills