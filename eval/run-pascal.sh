#!/bin/bash
# STDERR to /dev/null because of ld warnings from Fedora's `fpc`...
fpc $1 -o$1.out >/dev/null 2>&1 && ./$1.out
