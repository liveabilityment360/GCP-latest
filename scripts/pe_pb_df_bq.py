import argparse
import json
import os
import csv
import io
import logging
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions, StandardOptions
logging.basicConfig(level=logging.INFO)
logging.getLogger().setLevel(logging.INFO)

# Service account key path
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "/home/itproject2022bootcamp/gcp-project-346311-c1a147614e5f.json"
INPUT_SUBSCRIPTION = "projects/gcp-project-346311/subscriptions/priv-equity-sub"
BIGQUERY_TABLE = "gcp-project-346311:private_equity.raw_priv_equi"
BIGQUERY_SCHEMA ="timestamp:TIMESTAMP,company_name:STRING,growth_stage:STRING,country:STRING,state:STRING,city:STRING,continent:STRING,industry:STRING,sub_industry:STRING,client_focus:STRING,business_model:STRING,company_status:STRING,round:STRING,amount_raised:STRING,currency:STRING,date:STRING,quarter:STRING,Month:STRING,Year:STRING,investor_types:STRING,investor_name:STRING,company_valuation_usd:STRING,valuation_date:STRING"
#BIGQUERY_SCHEMA = "id:NUMERIC,ticker:STRING,title:STRING,category:STRING,content:STRING,release_date:DATE,provider:STRING,url:STRING,article_id:NUMERIC"
class CustomParsing(beam.DoFn):
    # Custom ParallelDo class to apply a custom transformation
    def to_runner_api_parameter(self, unused_context):
      # Not very relevant, returns a URN (uniform resource name) and the payload
        return "beam:transforms:custom_parsing:custom_v0", None
    def process(self,element:bytes, window=beam.DoFn.WindowParam):
      # Simple processing function to parse the data.
        element=element.decode('utf-8').split(",")
        row= {
            'timestamp': element[0],
            'company_name': element[1],
            'growth_stage': element[2],
            'country': element[3],
            'state': element[4],
            'city': element[5],
            'continent': element[6],
            'industry':element[7],
            'sub_industry':element[8],
            'client_focus':element[9],
            'business_model':element[10],
            'company_status':element[11],
            'round':element[12],
            'amount_raised':element[13],
            'currency':element[14],
            'date':element[15],
            'quarter':element[16],
            'month':element[17],
            'year':element[18],
            'investor_types':element[19],
            'investor_name':element[20],
            'company_valuation_usd':element[21],
            'valuation_date':element[22],
        }
        yield(row)
def run():
      # Parsing arguments
       parser = argparse.ArgumentParser()
       parser.add_argument(
       "--input_subscription",
       help='Input PubSub subscription of the form "projects/<PROJECT>/subscriptions/<SUBSCRIPTION>.',
       default=INPUT_SUBSCRIPTION,
       )
       parser.add_argument(
       "--output_table", help="Output BigQuery Table", default=BIGQUERY_TABLE
                           )
       parser.add_argument(
       "--output_schema",
       help="Output BigQuery Schema in text format",
       default=BIGQUERY_SCHEMA,
                           )
       known_args, pipeline_args = parser.parse_known_args()
  # Creating pipeline options
       pipeline_options = PipelineOptions(pipeline_args,runner='DataflowRunner',project='gcp-project-346311',job_name='finfo-pbsb-bq-df',temp_location='gs://private_equity/temp', region='australia-southeast2')
       pipeline_options.view_as(StandardOptions).streaming = True
# Defining our pipeline and its steps
       with beam.Pipeline(options=pipeline_options) as p:
         (
               p
               | "ReadFromPubSub" >> beam.io.gcp.pubsub.ReadFromPubSub(subscription=known_args.input_subscription)
               | "CustomParse" >> beam.ParDo(CustomParsing()) 
               | "WriteToBigQuery" >> beam.io.WriteToBigQuery(known_args.output_table,schema=known_args.output_schema,
                  write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND,)
           )
     
if __name__ == "__main__":
    run()
