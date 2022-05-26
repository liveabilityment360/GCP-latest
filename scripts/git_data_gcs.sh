#!/bin/bash
cd
gsutil cp 'finfo/data/raw_pe_tdata.csv' gs://private_equity/pe_data
gsutil cp 'finfo/data/dim_date.csv' gs://private_equity/pe_data
