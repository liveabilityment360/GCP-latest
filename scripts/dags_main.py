# This DAG relies on an Airflow variable
#https: // airflow.apache.org / docs / apache - airflow / stable / concepts / variables.html
#* project_id - Google Cloud Project ID to use for the Cloud Dataproc Template.


import datetime

from airflow import models
#from airflow.providers.google.cloud.operators.dataproc import DataprocInstantiateWorkflowTemplateOperator
from airflow.utils.dates import days_ago
from airflow.operators.python_operator import PythonOperator
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from scripts import gcs_data_simu_pbsb 

#project_id = models.Variable.get("gcp-project-346311")


default_args = {
    # Tell airflow to start one day ago, so that it runs as soon as you upload it
    "start_date": days_ago(1),
    #"gcp-project-346311": project_id,
}

# Define a DAG (directed acyclic graph) of tasks.
# Any task you create within the context manager is automatically added to the
# DAG object.
with models.DAG(
    # The id you will see in the DAG airflow page
    "finfo_dag",
    default_args=default_args,
    # The interval with which to schedule the DAG
    schedule_interval=datetime.timedelta(days=1),  # Override to match your needs
) as dag: 



    #gcs_data = BashOperator(
        #task_id="gcs_data",
        #bash_command="python3 gcs_data_simu_pbsb.py",

    #)

    gcs_data = PythonOperator(
        task_id='gcs_data',
	dag=dag,
        python_callable=gcs_data_simu_pbsb.main,

    )
    gcs_data
	

