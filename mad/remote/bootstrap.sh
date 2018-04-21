#!/bin/sh

set -a 
source /etc/default/metron 

sudo yum install -y epel-release
sudo yum clean metadata
sudo yum install -y python-pip
sudo pip install numpy

if [ ! -f ${METRON_HOME}/config/zookeeper/profiler.json ] 
then 
  echo '{ "profiles" : [] }' | sudo tee ${METRON_HOME}/config/zookeeper/profiler.json
  sudo $METRON_HOME/bin/zk_load_configs.sh -z $ZOOKEEPER -m PUSH -i ${METRON_HOME}/config/zookeeper/
fi

# Run the profile patch 
$METRON_HOME/bin/zk_load_configs.sh -z $ZOOKEEPER -m PATCH -c PROFILER -pf ~/mad/profiler_patch.json
