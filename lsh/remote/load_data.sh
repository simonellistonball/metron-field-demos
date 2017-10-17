#!/bin/sh 

source /etc/default/metron

COWRIE_HOME=~/lsh

pushd $COWRIE_HOME

if [ ! -f cowrie.1626302-1636522.json ]; then
  if [ ! -f 180424243034750.tar.gz ]; then
    curl -O https://raw.githubusercontent.com/fluenda/dataworks_summit_iot_botnet/master/180424243034750.tar.gz
  fi
  tar zxvf 180424243034750.tar.gz
fi

for i in cowrie.1626302-1636522.json cowrie.16879981-16892488.json cowrie.21312194-21331475.json cowrie.698260-710913.json cowrie.762933-772239.json cowrie.929866-939552.json cowrie.1246880-1248235.json cowrie.19285959-19295444.json cowrie.16542668-16581213.json cowrie.5849832-5871517.json cowrie.6607473-6609163.json
do
  echo "Loading $i"
  cat $i | /usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh --broker-list ${BROKERLIST} --topic cowrie
  sleep 2
done

popd
