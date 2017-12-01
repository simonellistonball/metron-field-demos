#!/bin/sh
source /etc/default/metron

sudo -t $METRON_HOME/bin/zk_load_configs.sh -m PULL -o ${METRON_HOME}/config/zookeeper/ -f 

if [ ! -f ${METRON_HOME}/config/zookeeper/profiler.json ] 
then 
  echo '{ "profiles" : [] }' | sudo -t tee ${METRON_HOME}/config/zookeeper/profiler.json
  sudo -t $METRON_HOME/bin/zk_load_configs.sh -m PUSH -i ${METRON_HOME}/config/zookeeper/
fi

$METRON_HOME/bin/zk_load_configs.sh -z $ZOOKEEPER -m PATCH -c PROFILER -pf ~/auth/profiler_patch.json
