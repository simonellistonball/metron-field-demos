#!/bin/sh

curl -X DELETE $ES_URL/cowrie*

echo "Note does not currently clear out HDFS store"
