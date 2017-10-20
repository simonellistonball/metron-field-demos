#!/bin/sh

# setup metron bits
echo "Setting up Parser"
curl -X POST -u admin:admin -d@parser.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/parser/config 
echo "\nSetting up Enrichment"
curl -X POST -u admin:admin -d@enrichment.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/enrichment/config/auth
echo "\nSetting up Indexing"
curl -X POST -u admin:admin -d@indexing.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/indexing/config/auth
echo "\nConfigure ES template"
curl -X POST -d@es.json -H 'Content-Type: application/json' $ES_URL/_template/auth
echo "Setup kafka"
curl -X POST -u admin:admin -d@kafka.json -H 'Content-Type: application/json' $REST_URL/api/v1/kafka/topic


pushd demo_loader 
mvn clean package -T2C && cp target/*.jar ../remote/
popd

# create the patch for the profiler config 
cat profiler.json | python ../profiler_patch.py > remote/profiler_patch.json

echo "\nUpload sample data"
ssh ${METRON_HOST} mkdir auth
rsync -zre ssh remote/ ${METRON_HOST}:auth/
echo "\nBootstrapping remote"
ssh ${METRON_HOST} '~/auth/bootstrap.sh'

# do a run for Fun
curl -u admin:admin ${REST_URL}/api/v1/storm/parser/start/auth 
