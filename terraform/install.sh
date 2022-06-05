#! /bin/bash
apt update
apt -y install apache2
#apt-get update
apt install git
apt-get install apache2 php7.0
apt install python3-pip
pip install google-cloud
pip install google-cloud-pubsub
python3 -m pip install --upgrade pip
pip install apache-beam
pip install apitools
pip install api-base
pip install --upgrade google-cloud-storage
cat <<EOF > /var/www/html/index.html
<html><body><p>Linux startup script from a local file.</p></body></html>

