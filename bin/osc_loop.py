#!/usr/bin/env python3

import liblo
import sys

def get_int(path, args):
    print(path)
    print(args)

try:
    server = liblo.Server(8017)
except Exception as err:
    print(err)
    sys.exit(1)


server.add_method("/heartbeat", None, get_int)
print("AkJ initialised.")

try:
    ardour = liblo.Address(3819)
except Exception as err:
    print(err)
    sys.exit
print("Ardour port opened")

print("entering loop")
liblo.send(ardour, "/set_surface/feedback", 8)

while True:
    if server.recv(50) == True:
        break
    liblo.send(ardour, "/set_surface/feedback", 8)

print("Got heartbeat")

liblo.send(ardour, "/loop_toggle", 1)
