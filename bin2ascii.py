#!/usr/bin/env python
# based on Lequn Chen's Code
import os
import sys
import binascii

INPUT = sys.argv[1]
OUTPUT = sys.argv[2]

s = open(INPUT, 'rb').read()
s = str(binascii.b2a_hex(s))
with open(OUTPUT, 'w') as f:
    for i in range(0, len(s), 8):
        f.write(s[i:i+2])
        f.write('\n')
        f.write(s[i+2:i+4])
        f.write('\n')
        f.write(s[i+4:i+6])
        f.write('\n')
        f.write(s[i+6:i+8])
        f.write('\n')
