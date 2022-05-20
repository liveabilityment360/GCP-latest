#!/bin/bash
<< Install 
   various installations required
   first Update the package lists on your instance, install the Git,
   Google cloud then pub sub and Set up the Apache2 HTTP Server.
   Install
   
sudo apt-get update 
sudo apt-get install git-core
sudo apt-get install apache2 php7.0
sudo apt install python3-pip
sudo pip install google-cloud
sudo pip install google-cloud-pubsub
python3 -m pip install --upgrade pip
pip install apache-beam
pip install apitools
