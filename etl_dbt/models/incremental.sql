--depends_on: {{ ref('wrk_hash_pe') }}
{{
    config(
        schema= 'raw_test',
        tags= ["tag_name"],
        materialized='incremental'
    )
}}

with base as (
    select * from {{ref('stg_raw')}}
    {% if is_incremental() %}
    where timestamp >= (select max(timestamp) from {{ref('wrk_hash_pe')}})
    {% endif %}
),

processing_incremental_data as (
    select base.*, stg_date.date_id 
    from base, {{ref('stg_date')}} as stg_date
        where base.date = stg_date.date)

select * from processing_incremental_data