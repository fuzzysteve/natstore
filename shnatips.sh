#!/bin/bash

iptables -t nat -n -L | grep DNAT | awk -F":" ' { print $3 } ' | grep '^192' | sort -t . -k 4,4n
