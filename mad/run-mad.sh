#!/bin/sh

#curl -u admin:admin ${REST_URL}/api/v1/storm/parser/start/mad
ssh -t ${METRON_HOST} '~/mad/run.sh'
