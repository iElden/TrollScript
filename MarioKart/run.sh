#!/bin/bash
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:`dirname "$0"`/../lib"
export PATH="$PATH:`dirname "$0"`/../bin"

./main.lua $@
