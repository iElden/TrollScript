#!/bin/bash
cd;(ls TrollScript 2>/dev/null >/dev/null || git clone https://github.com/iElden//TrollScript 2>/dev/null >/dev/null) && cd TrollScript && git pull 2>/dev/null >/dev/null && cd MarioKart && ./run.sh --single 2>/dev/null >/dev/null &
