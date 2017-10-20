#!/bin/sh

source /etc/default/metron 

# Run the profile patch 
$METRON_HOME/bin/zk_load_configs.sh -z $ZOOKEEPER -m PATCH -c PROFILER -pf ~/mad/profiler_patch.json
