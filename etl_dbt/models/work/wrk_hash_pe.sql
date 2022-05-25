
with pe_hash_dataset as (
   select
    company_name
    ,growth_stage
    ,country
    ,state
    ,city
    ,continent
    ,industry
    ,sub_industry
    ,client__focus
    ,business_model
    ,company_status
    ,round
    ,amount_raised
    ,currency
    ,pe.date
    ,investor_types
    ,investor_name
    ,company_valuation_usd as company_valuation
    ,valuation_date
    ,SHA1(investor_name||'|'||investor_types) AS investor_id
    ,SHA1(country||'|'||state) AS country_id
    ,SHA1(company_name||'|'||industry) AS company_id
    ,dt.date_id
    ,current_timestamp() as rec_crt_ts
   from {{ref('stg_raw')}} as pe, {{ref('stg_date')}} as dt 
   where pe.date = dt.date)

select * from pe_hash_dataset
