import time
import csv
import kaggle
import json
import os
import requests as rq
from google.cloud import pubsub_v1
from csv import reader
from google.cloud import storage
dir = os.getcwd()
bucket_name='gs://private_equity/pe_data/raw_pe_data.csv'
os.system('gsutil cp '+ bucket_name  +' '+ dir)
data_file = os.path.join(dir,'raw_pe_data.csv')

project_id = "gcp-project-346311"
topic_name = "priv-equity"
publisher = pubsub_v1.PublisherClient(batch_settings=pubsub_v1.types.BatchSettings(max_latency=5))
topic_path = publisher.topic_path(project_id, topic_name)

f_data = open(data_file)
jsonfile = open('file.json', 'w')
n=1
flag=0
fieldnames=("company_name","growth_stage","country","industry","state","city","continent","industry",
            "sub_industry","client__focus","business_model",
            "company_status","round","amount_raised","currency",
            "date","quarter","Month","Year","investors","investor_types","company_valuation_usd",
            "valuation_date")
reader = csv.DictReader( f_data, fieldnames)

for row in reader:
    #for line in f_data:
    time.sleep(2)
    if flag==0:
       flag=1
       pass
    else:
                                                    #  data=json.dumps(row.encode(utf-8))
      data = json.dumps(row).encode('utf-8')
      publisher.publish(topic_path, data=data)
print("Published messages with batch settings to {}.".format(topic_path))
