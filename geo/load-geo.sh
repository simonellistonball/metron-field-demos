#!/bin/sh

# setup metron bits
echo "Setting up Parser"
curl -X POST -u admin:admin -d@parser.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/parser/config 
echo "\nSetting up Enrichment"
curl -X POST -u admin:admin -d@enrichment.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/enrichment/config/geohash
echo "\nSetting up Indexing"
curl -X POST -u admin:admin -d@indexing.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/indexing/config/geohash
echo "\nConfigure ES template"
curl -X POST -d@es.json -H 'Content-Type: application/json' $ES_URL/_template/geohash
echo "Setup kafka"
curl -X POST -u admin:admin -d@kafka.json -H 'Content-Type: application/json' $REST_URL/api/v1/kafka/topic

# create the patch for the profiler config 
cat profiler.json | python ../profiler_patch.py > remote/profiler_patch.json

echo "\nUpload sample data"
ssh -t ${METRON_HOST} mkdir geohash
rsync -zre ssh remote/ ${METRON_HOST}:geohash/
ssh -t ${METRON_HOST} '~/geohash/bootstrap.sh'

# do a run for Fun
echo "\nStarting parser"
curl -u admin:admin ${REST_URL}/api/v1/storm/parser/start/geohash 
#ssh -t ${METRON_HOST} '~/geohash/load_data.sh'
