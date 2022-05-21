1) First run,the bash script, 'git_data_GCS.sh' using 'bash git_data_gcs.sh' to get the data from git repo to gcs bucket.

2) Then run, python script to simulate the data from gcs bucket to pubsub using command'$ nohup python3 gcs_data_simu_pbsb.py --speedFactor=20000 --project="gcp-project-346311" &'.

3) Then run, python script to run data flow job to parse data from pub/sub and transfer it to big query table using command " python3 pe_pb_df_bq.py --streaming".
