#!/bin/sh

set -a 
source /etc/default/metron
source ~/workday/workday-venv/bin/activate
cd ~/workday

python ~/workday/simulate.py --bootstrap-servers $BROKERLIST --interval 1 
