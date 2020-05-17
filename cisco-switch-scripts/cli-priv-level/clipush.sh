#!/bin/bash

# Enter username and password auto

# Open device list & send the collected information to script
for device in `cat switch`; 
do
    ./cliconf.sh $device;
done
