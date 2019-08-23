#!/bin/bash


# Script needs single argument
if [ $# -ne 1 ]
then
echo "A single string only" 2> error.log
exit 1
fi

iptables -t nat -n -L --line-numbers | grep DNAT | grep -i $1 > /tmp/natdel.out
if [ $? -gt 0 ]
then
echo no matches found
exit 1
else :
fi

count=$(cat /tmp/natdel.out | wc -l)

if [ $count -gt 1 ]
then
echo
echo more than one match found
else :
fi

echo

echo here are the matches:
echo
cat /tmp/natdel.out
echo

echo So the nat rules for deletion are:

cat /tmp/natdel.out | awk ' {print $1} '

echo These will need to be deleted one at a time...
