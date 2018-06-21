#!/bin/python3
import random, os, time

canBip = True

def heyListenMyLife(messages):
    for msg in messages:
        if msg:
            if canBip:
                if os.system("ffplay -nodisp -autoexit bip.mp3 1>&2 2> /dev/null &"): canPib = False
            os.system('notify-send -t 10000 -i ~/TrollScript/DrawMyLife/me.png "Elden the Dragon" "{}"'.format(msg))
            time.sleep(random.randint(0, 4) + 3)

with open("salutations.txt") as fd: heyListenMyLife(fd.read().split('\n'))
files = os.listdir('txt')
while files:
    f = random.choice(files)
    files.remove(f)
    with open ("txt/" + f) as fd : heyListenMyLife(fd.read().split('\n'));
