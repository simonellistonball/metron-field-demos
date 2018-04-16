#!/bin/sh

# setup metron bits - parser is already out of the box
echo "\nSetting up Enrichment"
curl -X POST -u admin:admin -d@enrichment.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/enrichment/config/squid
echo "\nSetting up Indexing"
curl -X POST -u admin:admin -d@indexing.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/indexing/config/squid
echo "\nConfigure ES template"
curl -X POST -d@es.json -H 'Content-Type: application/json' $ES_URL/_template/squid
echo "Setup kafka"
curl -X POST -u admin:admin -d@kafka.json -H 'Content-Type: application/json' $REST_URL/api/v1/kafka/topic

echo "\nUpload sample data"
ssh -t ${METRON_HOST} mkdir typosquat
rsync -zre ssh remote/ ${METRON_HOST}:typosquat/
ssh -t ${METRON_HOST} -t typosquat/bootstrap.sh 

# do a run for Fun
curl -u admin:admin ${REST_URL}/api/v1/storm/parser/start/squid
