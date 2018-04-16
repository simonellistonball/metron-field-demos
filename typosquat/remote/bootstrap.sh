#!/bin/sh 

set -a 
source /etc/default/metron

$METRON_HOME/bin/flatfile_summarizer.sh -i ~/typosquat/top-10k.csv -o /tmp/reference/alexa10k_filter.ser -e ~/typosquat/extractor_filter.json -p 5 -om HDFS
