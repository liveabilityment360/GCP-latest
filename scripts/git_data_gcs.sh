#!/bin/bash
cd
gsutil cp 'finfo/data/raw_pe_tdata.csv' gs://private_equity/pe_data
gsutil cp 'finfo/data/dim_date.csv' gs://private_equity/pe_data
gsutil cp 'finfo/scripts/git_data_gcs.sh' gs://australia-southeast1-compos-ca616f74-bucket/dags
gsutil cp 'finfo/scripts/gcs_df_bq.py' gs://australia-southeast1-compos-ca616f74-bucket/dags
