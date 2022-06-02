#!/bin/bash
bq --location=australia-southeast2 mk -d gcp-project-346311:private_equity

bq mk   -t   --description "FINFO landing table"   \private_equity.raw_priv_equi  rec_crt_ts:TIMESTAMP,company_name:STRING,growth_stage:STRING,country:STRING,state:STRING,city:STRING,continent:STRING,industry:STRING,sub_industry:STRING,client_focus:STRING,business_model:STRING,company_status:STRING,round:STRING,amount_raised:STRING,currency:STRING,date:STRING,quarter:STRING,Month:STRING,Year:STRING,investor_types:STRING,investor_name:STRING,company_valuation_usd:STRING,valuation_date:STRING
# create partitioned table for fact_pe
bq mk -t \
  --schema 'country_id:BYTES,company_id:BYTES,investor_id:BYTES,date_id:INTEGER,rcd_date:DATE,funding_rnd:STRING,amount_raised:INTEGER,currency:STRING, unique_id:STRING, current_timestamp:TIMESTAMP' \
  --time_partitioning_field rcd_date \
  --time_partitioning_type DAY \
  private_equity.fact_pe
  
bq mkdef --source_format=CSV --autodetect=TRUE \
  gs://gcp-project-346311/dim_date.csv > dim_date_df
 
bq mk --table \
  --external_table_definition=dim_date_df \
  private_equity.dim_date

rm -f dim_date_df

#create dim_investor table
bq mk   -t   --description "FINFO investor dimension"   \private_equity.dim_investor  investor_name:STRING,investor_types:STRING,investor_id:BYTES,rec_crt_ts:TIMESTAMP

#create dim_country table
bq mk   -t   --description "FINFO country dimension"   \private_equity.dim_country  country:STRING,state:STRING,city:STRING,continent:STRING,country_id:BYTES,rec_crt_ts:TIMESTAMP

#create dim_company table
bq mk   -t   --description "FINFO company dimension"   \private_equity.dim_company  company_name:STRING,growth_stage:STRING,industry:STRING,sub_industry:STRING,client_focus:STRING,business_model:STRING,company_status:STRING,company_valuation:STRING,valuation_date:DATE,company_id:BYTES,rec_crt_ts:TIMESTAMP
  

