#!/bin/bash


# Script needs single argument
if [ $# -ne 1 ]
then
echo "A single string only" 2> error.log
exit 1
fi

# Third argument has to be a string with no spaces and max of 256 characters
if [[ $1 =~ ^[0-9]{1,3}$ ]]
then :
else echo "Has to be an integer with 3 max"
exit 6
fi


echo
echo "nat rule with line number $1 is about to be deleted - do you want to continue (y/n)?"
iptables -t nat -vnL --line-numbers | grep $1
echo
read ans


if [[ $ans = y || $ans = Y || $ans = yes || $ans = Yes || $ans = YES ]]
then
iptables -t nat -D PREROUTING $1
echo rule has been removed
fi

if [[ $ans = n || $ans = N || $ans = no || $ans = No || $ans = NO ]]
then
echo not deleting
exit
fi
