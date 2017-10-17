#!/bin/sh

source /etc/default/metron

python ~/geohash/gen_data.py | /usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh --broker-list $BROKERLIST --topic geohash
