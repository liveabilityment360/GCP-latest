#!/bin/bash
bq --location= $location mk -d gcp-project-346311:private_equity
bq mk   -t   --description "FINFO landing table"   \private_equity.raw_priv_equi  rec_crt_ts:TIMESTAMP,company_name:STRING,growth_stage:STRING,country:STRING,state:STRING,city:STRING,continent:STRING,industry:STRING,sub_industry:STRING,client_focus:STRING,business_model:STRING,company_status:STRING,round:STRING,amount_raised:STRING,currency:STRING,date:STRING,quarter:STRING,Month:STRING,Year:STRING,investor_types:STRING,investor_name:STRING,company_valuation_usd:STRING,valuation_date:STRING
# create partitioned table for fact_pe
bq mk -t \
  --schema 'country_id:BYTES,comapny_id:BYTES,investor_id:BYTES,date_id:INTEGER,rcd_date:DATE,funding_rnd:STRING,amount_raised:INTEGER,currency:STRING, unique_id:STRING, current_timestamp:TIMESTAMP' \
  --time_partitioning_field rcd_date \
  --time_partitioning_type DAY \
  private_equity.fact_pe
#create dim_investor table
bq --location= $location mk -d gcp-project-346311:private_equity
bq mk   -t   --description "FINFO investor dimension"   \private_equity.dim_investor  investor_name:STRING,investor_types:STRING,investor_id:BYTES,rec_crt_ts:TIMESTAMP

#create dim_country table
bq --location= $location mk -d gcp-project-346311:private_equity
bq mk   -t   --description "FINFO country dimension"   \private_equity.dim_country  country:STRING,state:STRING,city:STRING,continent:STRING,country_id:BYTES,rec_crt_ts:TIMESTAMP

#create dim_company table
bq --location= $location mk -d gcp-project-346311:private_equity
bq mk   -t   --description "FINFO company dimension"   \private_equity.dim_company  company_name:STRING,growth_stage:STRING,industry:STRING,sub_industry:STRING,client_focus:STRING,business_model:STRING,company_status:STRING,company_valuation:STRING,valuation_date:DATE,company_id:BYTES,rec_crt_ts:TIMESTAMP
  
  
bq mk \
--use_legacy_sql=false \
--expiration 0 \
--description "PE view" \
--view \
select d.year as Year,
d.month as Month,
c.company_name as Company, 
c.company_valuation as CompanyValuation,
c.industry as Industry,
c.sub_industry as SubIndustry,
c.growth_stage as GrowthStage,
a.country as Country,
a.state as State,
a.city as City,
b.investor_name as InvestorName,
b.investor_types as InvestorType,
f.amount_raised as AmountRaised
from `gcp-project-346311.private_equity.dim_company`c, 
`gcp-project-346311.private_equity.dim_country`a,
`gcp-project-346311.private_equity.dim_date` d,
`gcp-project-346311.private_equity.dim_investor`b,
`gcp-project-346311.private_equity.fact_pe` f
where f.date_id = d.date_id
and f.company_id = c.company_id
and f.country_id = a.country_id
group by d.year,d.Month, c.company_name,a.country,c.company_valuation,c.industry,c.sub_industry,c.growth_stage,b.investor_name,b.investor_types, a.state,a.city,f.amount_raised
Order by AmountRaised;
private_equity.pe_view

