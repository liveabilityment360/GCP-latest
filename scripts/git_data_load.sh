#!/bin/bash
cd
# copying raw data and dim_date csv files in GCS bucket.
gsutil cp 'finfo/data/raw_pe_tdata.csv' gs://private_equity/pe_data
gsutil cp 'finfo/data/dim_date.csv' gs://private_equity/pe_data

# loading dim_date into date dimesion table.
    bq load \
    --source_format=CSV \
    private_equity.dim_date\
    gs://private_equity/pe_data/dim_date1.csv \
    year:INTEGER,month:INTEGER,day:INTEGER,date:DATE,date_id:INTEGER,date_name:DATE,fiscal_year:INTEGER,fiscal_quarter:INTEGER,calendar_quarter:INTEGER,is_week_day:BOOLEAN,day_of_week:INTEGER,month_name:STRING,day_of_week_name:STRING

# copying scripts for cloud composer in dags folder
gsutil cp 'finfo/scripts/git_data_gcs.sh' gs://australia-southeast1-compos-ca616f74-bucket/dags
gsutil cp 'finfo/scripts/gcs_df_bq.py' gs://australia-southeast1-compos-ca616f74-bucket/dags


