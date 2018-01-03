#!/bin/sh

source /etc/default/metron

echo -e "import time\nprint 'user1,109.252.227.173,'+str(int(time.time()*1000))" | python | /usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh --broker-list $BROKERLIST --topic geohash
