#!/bin/bash
bq --location= $location mk -d gcp-project-346311:private_equity
bq mk   -t   --description "FINFO landing table"   \private_equity.raw_priv_equi  timestamp:TIMESTAMP,company_name:STRING,growth_stage:STRING,country:STRING,state:STRING,city:STRING,continent:STRING,industry:STRING,sub_industry:STRING,client_focus:STRING,business_model:STRING,company_status:STRING,round:STRING,amount_raised:STRING,currency:STRING,date:STRING,quarter:STRING,month:STRING,year:STRING,investor_types:STRING,investor_name:STRING,company_valuation_usd:STRING,valuation_date:STRING
