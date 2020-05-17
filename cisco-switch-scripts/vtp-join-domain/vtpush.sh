#!/bin/bash

# Open device list & send the collected information to script
for device in `cat switch`; 
do
    ./vtpDomain.sh $device;
    #./vtpTransparent.sh $device;
done
