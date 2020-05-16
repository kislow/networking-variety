#!/bin/bash

# Change your mac address to a private random address

currentmac=`ifconfig en0 | grep ether`
newmac=`ifconfig en0 | grep ether`
cm= `openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether`
echo "Current mac address:$currentmac"
echo "$cm ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
echo "New mac address:$newmac"
