#!/bin/sh

# setup metron bits
echo "Setting up Parser"
curl -X POST -u admin:admin -d@parser.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/parser/config 
echo "\nSetting up Enrichment"
curl -X POST -u admin:admin -d@enrichment.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/enrichment/config/cowrie
echo "\nSetting up Indexing"
curl -X POST -u admin:admin -d@indexing.json -H 'Content-Type: application/json' $REST_URL/api/v1/sensor/indexing/config/cowrie
echo "\nConfigure ES template"
curl -X POST -d@es.json -H 'Content-Type: application/json' $ES_URL/_template/cowrie
echo "Setup kafka"
curl -X POST -u admin:admin -d@kafka.json -H 'Content-Type: application/json' $REST_URL/api/v1/kafka/topic

echo "\nUpload sample data"
ssh ${METRON_HOST} mkdir lsh
rsync -zre ssh remote/ ${METRON_HOST}:lsh/
ssh ${METRON_HOST} 'cd lsh; tar zxf *.tar.gz'

echo "\nLoad the threat intel data"
ssh ${METRON_HOST} '/usr/hcp/current/metron/bin/flatfile_loader.sh -i ~/lsh/blacklist.csv -t threatintel -c t -e ~/lsh/blacklist.extractor.json'

# do a run for Fun
curl -u admin:admin ${REST_URL}/api/v1/storm/parser/start/cowrie 
ssh ${METRON_HOST} '~/lsh/load_data.sh'
