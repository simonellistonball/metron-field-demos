#!/usr/bin/python

import random
import sys
import time

domains = { 'user1' : '173.90', 'user2' : '156.33' }

def get_ip(base):
  return base + '.' + str(random.randint(1,255)) + '.' + str(random.randint(1, 255))

def main():
  freq_s = 60
  while True:
    user='user' + str(random.randint(1,len(domains)))
    epoch_time = int(time.time()) * 1000
    ip=get_ip(domains[user])
    print user + ',' + ip + ',' + str(epoch_time)
    sys.stdout.flush()
    time.sleep(freq_s)

if __name__ == '__main__':
  main()
