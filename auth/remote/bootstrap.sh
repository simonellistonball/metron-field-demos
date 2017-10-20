#!/bin/sh
source /etc/default/metron

$METRON_HOME/bin/zk_load_configs.sh -z $ZOOKEEPER -m PATCH -c PROFILER -pf ~/auth/profiler_patch.json
