#!/bin/python3

import sys, time, random, os

tmp = int(sys.argv[1]) if len(sys.argv) >= 2 else 120;
while True:
    langage = "".join([chr(random.randint(97, 122)) for i in range(2)]);
    if not os.system("setxkbmap {} 2>/dev/null".format(langage)):
        time.sleep(tmp)
