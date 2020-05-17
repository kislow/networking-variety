#!/bin/bash

# Collect username, ssh, & enable passwords

echo "Enter the username: "
read -s -e user
echo "Enter the SSH password: "
read -s -e password

#--- uncomment section if "Enable password" is in place---#
#echo "Enter the Enable password: "
#read -s -e enable
#----------------------------------------------------------#

# Open device list & send the collected information to script
for device in `cat switches`; 
do 
    ./push_binfile.sh $device $user $password ;
done
