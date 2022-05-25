with investor as (
    select distinct
        investor_name
        ,investor_types
        ,investor_id
        ,current_timestamp() as rec_crt_ts
    from {{ref('wrk_hash_pe')}})

select * from investor