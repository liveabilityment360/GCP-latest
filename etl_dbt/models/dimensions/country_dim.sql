with country as (
    select distinct
        country
        ,state
        ,city
        ,continent
        ,country_id
        ,current_timestamp() as rec_crt_ts
    from {{ref('wrk_hash_pe')}})

select * from country
