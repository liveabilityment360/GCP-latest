#!/bin/bash
bq --location= $location mk -d gcp-project-346311:private_equity
bq mk   -t   --description "FINFO landing table"   \private_equity.raw_priv_equi  rec_crt_ts:TIMESTAMP,company_name:STRING,growth_stage:STRING,country:STRING,state:STRING,city:STRING,continent:STRING,industry:STRING,sub_industry:STRING,client_focus:STRING,business_model:STRING,company_status:STRING,round:STRING,amount_raised:STRING,currency:STRING,date:STRING,quarter:STRING,Month:STRING,Year:STRING,investor_types:STRING,investor_name:STRING,company_valuation_usd:STRING,valuation_date:STRING
# create partitioned table for fact_pe
bq mk -t \
  --schema 'country_id:BYTES,comapny_id:BYTES,investor_id:BYTES,date_id:INTEGER,rcd_date:DATE,funding_rnd:STRING,amount_raised:INTEGER,currency:STRING, unique_id:STRING, current_timestamp:TIMESTAMP' \
  --time_partitioning_field rcd_date \
  --time_partitioning_type DAY \
  private_equity.fact_pe
