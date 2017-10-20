#!/bin/sh

source /etc/default/metron

python ~/mad/rand_gen.py 0 1 1 | /usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh --broker-list $BROKERLIST --topic mad
