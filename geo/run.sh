#!/bin/sh

ssh ${METRON_HOST} 'python ~/geohash/gen_data.py | /usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh --broker-list sball-metron-0.field.hortonworks.com:6667 --topic geohash'
