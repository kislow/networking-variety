#!/bin/bash

# Open device list & send the collected information to script
for device in `cat switch`; 
do
    ./rconf.sh $device;
done
