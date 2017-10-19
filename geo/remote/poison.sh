#!/bin/sh

echo -e "import time\nprint 'user1,109.252.227.173,'+str(int(time.time()))" | python | /usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh --broker-list $BROKERLIST --topic geohash
