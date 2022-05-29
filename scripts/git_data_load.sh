#!/bin/bash
projectid=$1
dagpath=$2
cd
# copying raw data and dim_date csv files in GCS bucket.
gsutil cp 'finfo/data/raw_pe_tdata.csv' gs://$(gcloud config list --format 'value(core.project)' 2>/dev/null)
gsutil cp 'finfo/data/dim_date.csv' gs://$(gcloud config list --format 'value(core.project)' 2>/dev/null)
#gsutil cp 'finfo/data/dbtk.json' gs://$(gcloud config list --format 'value(core.project)' 2>/dev/null)
# loading dim_date into date dimesion table.
  
    bq load \
 --autodetect \
    --source_format=CSV \
    private_equity.dim_date\
    gs://gcp-project-346311/dim_date.csv

# copying scripts for cloud composer in dags folder
gsutil cp 'finfo/scripts/git_data_gcs.sh'  gs://australia-southeast1-finc3-f8af926e-bucket/dags
gsutil cp 'finfo/scripts/gcs_df_bq.py' gs://australia-southeast1-finc3-f8af926e-bucket/dags


