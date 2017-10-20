#!/bin/sh 

source /etc/default/metron

~/auth/demo_loader.sh -e 1848158 -c ~/auth/config.json -z $ZOOKEEPER -hf ~/auth/hostfilter.txt
