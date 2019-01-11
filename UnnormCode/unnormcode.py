#!/bin/python3
import sys

for file in sys.argv[1:]:
    with open(file, 'r') as fd: f = fd.read()
    f = f.replace('\n', ' ').replace('\t', ' ')
    while "  " in f: f = f.replace("  ", ' ')
    with open(file, 'w') as fd: fd.write(f)
