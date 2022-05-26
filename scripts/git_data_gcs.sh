#!/bin/bash
cd
# copying raw data and dim_date csv files in GCS bucket.
gsutil cp 'finfo/data/raw_pe_tdata.csv' gs://private_equity
