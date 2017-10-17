#!/bin/sh

#curl -u admin:admin ${REST_URL}/api/v1/storm/parser/start/cowrie 
ssh ${METRON_HOST} '~/lsh/load_data.sh'
