

# copying scripts for cloud composer in dags folder
cd
gsutil cp 'finfo/scripts/git_data_gcs.sh'  gs://australia-southeast1-cloudc-61378e87-bucket/dags
gsutil cp 'finfo/scripts/gcs_data_simu_pbsb.py' gs://australia-southeast1-cloudc-61378e87-bucket/dags
gsutil cp 'finfo/scripts/pe_pb_df_bq.py'  gs://australia-southeast1-cloudc-61378e87-bucket/dags

