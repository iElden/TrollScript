#!/bin/bash

for file in `ldd $1 | cut -d ' ' -f 1`; do
    echo $file
    if ls $file; then
	cp $file lib
    elif ls /usr/lib/$file; then
	cp /usr/lib/$file lib
    elif ls /usr/lib64/$file; then
	cp /usr/lib64/$file lib
    else
	echo Cannot find file $file
    fi
done
