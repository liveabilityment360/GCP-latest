with fact as (
    select
        country_id
        ,company_id
        ,investor_id
        ,date_id
        ,round
        ,cast(amount_raised as integer) as amount_raised
        ,currency
        ,current_timestamp() as rec_crt_ts
    from {{ref('wrk_hash_pe')}}
)

select * from fact
