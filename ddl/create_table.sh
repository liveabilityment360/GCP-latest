#!/bin/bash
bq --location= australia-southeast2  mk -d private_equity
bq mk   -t   --description "FINFO landing table"   \private_equity.test_priv_equi1  timestamp:TIMESTAMP,company_name:STRING,growth_stage:STRING,country:STRING,state:STRING,city:STRING,continent:STRING,industry:STRING,sub_industry:STRING,client_focus:STRING,business_model:STRING,company_status:STRING,round:STRING,amount_raised:STRING,currency:STRING,date:STRING,quarter:STRING,Month:STRING,Year:STRING,investor_types:STRING,investor_name:STRING,company_valuation_usd:STRING,valuation_date:STRING
