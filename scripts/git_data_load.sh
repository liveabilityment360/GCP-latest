#!/bin/bash
projectid=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
dagpath=$1

# copying raw data and dim_date csv files in GCS bucket.
gsutil cp ../data/raw_pe_tdata.csv gs://${projectid}
gsutil cp ../data/dim_date.csv gs://${projectid}
#gsutil cp ../data/dbtk.json gs://${projectid}
# loading dim_date into date dimesion table.
  
    bq load \
 --autodetect \
    --source_format=CSV \
    private_equity.dim_date\
    gs://${projectid}/dim_date.csv




