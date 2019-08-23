#!/bin/bash

iptables -t nat -n -L | grep DNAT | awk -F":" ' { print $4 } ' | sort -n
