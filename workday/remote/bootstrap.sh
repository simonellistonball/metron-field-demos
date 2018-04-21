#!/bin/sh 

set -a 
source /etc/default/metron

sudo $METRON_HOME/bin/zk_load_configs.sh -m PULL -o ${METRON_HOME}/config/zookeeper/ -f 

if [ ! -f ${METRON_HOME}/config/zookeeper/profiler.json ] 
then 
  echo '{ "profiles" : [] }' | sudo tee ${METRON_HOME}/config/zookeeper/profiler.json
  sudo $METRON_HOME/bin/zk_load_configs.sh -z $ZOOKEEPER -m PUSH -i ${METRON_HOME}/config/zookeeper/
fi

$METRON_HOME/bin/zk_load_configs.sh -z $ZOOKEEPER -m PATCH -c PROFILER -pf ~/geohash/profiler_patch.json

sudo yum install python34 python34-setuptools
sudo easy_install-3.4 pip

pip install virtualenv

virtualenv --python=/usr/bin/python3.4 workday-venv
source workday-venv/bin/activate

pip install -r requirements.txt
