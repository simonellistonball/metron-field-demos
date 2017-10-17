#!/bin/sh

/usr/hcp/current/metron/bin/flatfile_loader.sh -i ~/auth/blacklist.csv -t threatintel -c t -e ~/auth/blacklist.extractor.json
