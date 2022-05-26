#!/bin/bash
cd
# copying raw data and dim_date csv files in GCS bucket.
gsutil cp 'finfo/data/raw_pe_tdata.csv' gs://private_equity
gsutil cp 'finfo/data/dim_date.csv' gs://private_equity

# loading dim_date into date dimesion table.
  
    bq load \
 --autodetect \
    --source_format=CSV \
    private_equity.dim_date\
    gs://private_equity/pe_data_dim_date.csv

# copying scripts for cloud composer in dags folder
gsutil cp 'finfo/scripts/git_data_gcs.sh' gs://australia-southeast1-compos-ca616f74-bucket/dags
gsutil cp 'finfo/scripts/gcs_df_bq.py' gs://australia-southeast1-compos-ca616f74-bucket/dags


