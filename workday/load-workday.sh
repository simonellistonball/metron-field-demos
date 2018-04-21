#!/bin/sh

# setup metron bits - parser is already out of the box
upload() {
  topic=$1
  echo "\nSetting up Parser (${topic})"
  curl -X POST -u admin:admin -d@${topic}/parser.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/parser/config/${topic}
  echo "\nSetting up Enrichment (${topic})"
  curl -X POST -u admin:admin -d@${topic}/enrichment.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/enrichment/config/${topic}
  echo "\nSetting up Indexing (${topic})"
  curl -X POST -u admin:admin -d@${topic}/indexing.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/indexing/config/${topic}
  echo "\nConfigure ES template (${topic})"
  curl -X POST -d@${topic}/es.json -H 'Content-Type: application/json' $ES_URL/_template/${topic}
  echo "Setup kafka (${topic})"
  curl -X POST -u admin:admin -d@${topic}/kafka.json -H 'Content-Type: application/json' $REST_URL/api/v1/kafka/topic
  #echo "Starting the parser"
  #curl -u admin:admin ${REST_URL}/api/v1/storm/parser/start/email
}

# create the patch for the profiler config 
cat profiler.json | python ../profiler_patch.py > remote/profiler_patch.json

echo "\nUpload sample data"
ssh -t ${METRON_HOST} mkdir workday
rsync -zre ssh remote/ ${METRON_HOST}:workday/
ssh -t ${METRON_HOST} -t workday/bootstrap.sh 

upload email
upload web
upload login
