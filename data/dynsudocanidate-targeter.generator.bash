#!/bin/bash
( for x in /sbin /usr/sbin; do cd $x; find -regextype posix-egrep -iregex '\.\/[a-z24]{3,8}' -printf '%f\n';echo; done ) | grep -P '^[a-z]+.*[a-z]+$' | sort | uniq -w 4 | tr '\n' ' '
