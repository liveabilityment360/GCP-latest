#!/bin/bash
git clone https://github.com/FINFO-GCP-Project/FINFO.git
cd FINFO
cd Data
gsutil cp 'raw_pe_data.csv' gs://finfo-2022
