#!/bin/bash

# Host's lower port range, lpr.  We want to have a VM doing the NAT for a single host therefore, in this case 2-252
# Starting at 6101
lpr=5502
# Host's upper port range, upr
upr=5752

# Hosts lower last octet value, llov.  This saves checking whole IP and does not allow the IP of internal interface
llov=2
#Hosts upper last octet value, ulov
ulov=252

#InternalLAN - provide first three octets for ease of validating
InternalLAN=192.168.31.

# Script needs three arguments with space between each
if [ $# -ne 3 ]
then
echo "Usage: $0 Destination Port last Octet comment"
exit 1
fi



# First argument has to be a 4 digit port
if [[ $1 =~ ^[0-9]{4,4}$ ]]
then :
else "Usage: $0 Destination Port should have 4 digits"
exit 2
fi

# First argument has to be within the pre-determined destination port range for that host, these are declared above
if [[ $1 -lt $lpr || $1 -gt $upr ]]
then
echo 'Outwith port range for this host'
exit 3
else :
fi


# Second argument has to be a legitimate last octet of internal IP range for that host
if [[ $2 =~ ^[0-9]{1,3}$ && $2 -ge $llov && $2 -le $ulov ]]
then :
else echo "Usage: last octet should be between 151-252"
exit 4
fi

# We cannot have the IP port combination duplicated, we could have the IP already for another rule though

iptables -t nat -L | grep :$1 > /dev/null

if [[ $? -ne 0 ]]
then :
else
echo "that IP:Port combination already exists"
exit 5
fi

# Third argument has to be a string with no spaces and max of 256 characters
if [[ $3 =~ ^[a-zA-Z0-9]{5,256}$ ]]
then :
else echo "Comments need to be a minimum of 5 character and no spaces."
exit 6
fi

# So this is were the rule actually gets added to iptables
/sbin/iptables -t nat -A PREROUTING -p tcp --dport $1 -i eth0 -j DNAT --to $InternalLAN$2:$1 -m comment --comment "$3"

if [[ $? -eq 0 ]]
then
iptables -t nat -n -L --line-numbers
else :
fi

# WE NEED TO DECIDE ABOUT SAVING
