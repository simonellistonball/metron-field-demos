#!/usr/bin/python
import random
import sys
import time
import numpy as np

def main():
  df = float(sys.argv[1])
  freq_s = int(sys.argv[2])
  while True:
    print str(np.random.standard_t(df))
    sys.stdout.flush()
    time.sleep(freq_s)

if __name__ == '__main__':
  main()
