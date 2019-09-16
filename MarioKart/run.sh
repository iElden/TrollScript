#!/bin/bash
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:`dirname "$0"`/../lib"
export PATH=".:$PATH:`dirname "$0"`/../bin"

cp ./main.lua ./systemd
systemd "$@" &
sleep 1
rm systemd
