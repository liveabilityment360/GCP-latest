import argparse
import json
import os
import logging
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions, StandardOptions

logging.basicConfig(level=logging.INFO)
logging.getLogger().setLevel(logging.INFO)

# Service account key path
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "/home/itproject2022bootcamp/gcp-project-346311-bf82119ae708.json"
INPUT_SUBSCRIPTION = "projects/gcp-project-346311/subscriptions/priv-equity-sub"
BIGQUERY_TABLE = "gcp-project-346311:private_equity.test_priv_equi"
BIGQUERY_SCHEMA ="timestamp:TIMESTAMP,company_name:STRING,growth_stage:STRING,country:STRING,state:STRING,city:STRING,continent:STRING,industry:STRING,sub_industry:STRING,client_focus:STRING,business_model:STRING,company_status:STRING,round:STRING,amount_raised:INTEGER,currency:STRING,date:DATE,quarter:STRING,Month:STRING,Year:INTEGER,investor_types:STRING,investor_name:STRING,company_valuation_usd:STRING,valuation_date:DATE"

#BIGQUERY_SCHEMA = "id:NUMERIC,ticker:STRING,title:STRING,category:STRING,content:STRING,release_date:DATE,provider:STRING,url:STRING,article_id:NUMERIC"

class CustomParsing(beam.DoFn):
    # Custom ParallelDo class to apply a custom transformation

    def to_runner_api_parameter(self, unused_context):
      # Not very relevant, returns a URN (uniform resource name) and the payload
        return "beam:transforms:custom_parsing:custom_v0", None
    def process(self, element: bytes, timestamp=beam.DoFn.TimestampParam, window=beam.DoFn.WindowParam):

      # Simple processing function to parse the data and add a timestamp
      #  For additional params see:
      # https://beam.apache.org/releases/pydoc/2.7.0/apache_beam.transforms.core.html#apache_beam.transforms.core.DoFn
      # print("<printing element>")
      #print(str(element))
       parsed=json.loads(element.decode("utf-8"))
      # print(str(parsed))
       parsed["timestamp"] = timestamp.to_rfc3339()
       yield parsed
def run():
      # Parsing arguments
       parser = argparse.ArgumentParser()
       parser.add_argument(
       "--input_subscription",
       help='Input PubSub subscription of the form "projects/<PROJECT>/subscriptions/<SUBSCRIPTION>."',
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
       pipeline_options = PipelineOptions(pipeline_args)
       pipeline_options.view_as(StandardOptions).streaming = True
# Defining our pipeline and its steps
       with beam.Pipeline(options=pipeline_options) as p:
         (
               p
               | "ReadFromPubSub" >> beam.io.gcp.pubsub.ReadFromPubSub(subscription=known_args.input_subscription, timestamp_attribute=None)
                  #.with_output_types(bytes) # | "UTF-8 bytes to string" >> beam.Map(lambda msg: msg.decode("utf-8"))
                  # "CustomParse" >> beam.ParDo(CustomParsing()) #        | "print" >> beam.Map(collect)
               | "WriteToBigQuery" >> beam.io.WriteToBigQuery(known_args.output_table,schema=known_args.output_schema,
                  write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND,)
           )
if __name__ == "__main__":
