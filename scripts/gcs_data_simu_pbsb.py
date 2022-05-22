import time
import csv
import json
import os
import requests as rq
import logging
import argparse
import datetime
#from google.cloud import pubsub
from google.cloud import pubsub
from csv import reader
from google.cloud import storage
dir = os.getcwd()
bucket_name='gs://private_equity/pe_data/raw_pe_data.csv'
os.system('gsutil cp '+ bucket_name  +' '+ dir)
data_file = os.path.join(dir,'raw_pe_data.csv')

TIME_FORMAT = '%Y-%m-%d %H:%M:%S'
TOPIC = 'priv-equity'
INPUT = 'raw_pe_data.csv'

def publish(publisher, topic, events):
   numobs = len(events)
   if numobs > 0:
      # logging.info('Publishing {0} events from {1}'.format(numobs, get_timestamp(events[0])))
       for event_data in events:
         ## convert from bytes to str
          event_data = event_data.encode('utf-8')

          publisher.publish(topic,event_data)
def get_timestamp(row):
    ## convert from bytes to str
    #line = line.decode('utf-8')
     # look at first field of row
     line= ','.join([str(item)for item in row])
     timestamp = line.split(',')[0]
     #return(timestamp)
     return datetime.datetime.strptime(timestamp,TIME_FORMAT)


def simulate(topic, ifp, firstObsTime, programStart, speedFactor):
       # sleep computation
       def compute_sleep_secs(obs_time):
          time_elapsed = (datetime.datetime.utcnow() - programStart).seconds
          sim_time_elapsed = ((obs_time - firstObsTime).days * 86400.0 + (obs_time - firstObsTime).seconds) / speedFactor
          to_sleep_secs = sim_time_elapsed - time_elapsed
          return to_sleep_secs

       topublish = list()
       for line in ifp:
         event_data =','.join([str(item)for item in line])
         # entire line of input CSV is the message
         obs_time = get_timestamp(line) # from first column

       # how much time should we sleep?
         if compute_sleep_secs(obs_time) > 1:
          # notify the accumulated topublish
            publish(publisher, topic, topublish) # notify accumulated messages
            topublish = list() # empty out list

          # recompute sleep, since notification takes a while
            to_sleep_secs = compute_sleep_secs(obs_time)
            if to_sleep_secs > 0:
              logging.info('Sleeping {} seconds'.format(to_sleep_secs))
              time.sleep(to_sleep_secs)
         topublish.append(event_data)
      #  HEAD
      # print(event_data)
#=======
    #   print(event_data)
#>>>>>>> fdb923a5671c7ccd25ee30bd1281d21039ff4f62

   # left-over records; notify again
       publish(publisher, topic, topublish)
#def peek_timestamp(ifp):
      # peek ahead to next line, get timestamp and go back
 #     pos = ifp.tell()
      #line = ifp#.
    #  readline()
 #     ifp.seek(pos)
     # return get_timestamp(line)
#speedFactor=60
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Send sensor data to Cloud Pub/Sub in small groups, simulating real-time behavior')
    parser.add_argument('--speedFactor', help='Example: 60 implies 1 hour of data sent to Cloud Pub/Sub in 1 minute', required=True, type=float)
    parser.add_argument('--project', help='Example: --project $DEVSHELL_PROJECT_ID', required=True)
    args = parser.parse_args()

    # create Pub/Sub notification topic
logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)
publisher = pubsub.PublisherClient()
event_type = publisher.topic_path(args.project,TOPIC)
#try:
 #   publisher.get_topic(event_type)
  #  logging.info('Reusing pub/sub topic {}'.format(TOPIC))
#except:
 #   publisher.create_topic(event_type)
  #  logging.info('Creating pub/sub topic {}'.format(TOPIC))

    # notify about each line in the input file
programStartTime = datetime.datetime.utcnow()
f_data = open(data_file)
fieldnames=("date","company_name","growth_stage","country","industry",
            "sub_industry","client__focus","business_model",
            "company_status","round","amount_raised","currency",
            "date","quarter","Month","Year","investors","investor_types","company_valuation_usd",
            "valuation_date")
n=0
reader = csv.reader(f_data)
next(reader)
for row in reader:
        if(n<1):
           firstObsTime = get_timestamp(row)
           logging.info('Sending sensor data from {}'.format(firstObsTime))
        else:
            break
        n=n+1
       # print(firstObsTime)


#with gzip.open(INPUT, 'rb') as ifp:
#header = ifp.readline()  # skip header
        #firstObsTime = get_timestamp(row)
       # print (type(firstObsTime))
        #logging.info('Sending sensor data from {}'.format(firstObsTime))
simulate(event_type, reader, firstObsTime, programStartTime, args.speedFactor)
