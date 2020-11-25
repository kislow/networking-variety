#!/bin/bash

# identify default network interface 
GET_DEFAULT_INTERFACE=$(route | grep '^default' | grep -o '[^ ]*$')

# identify current MAC address
GET_MAC_ADDRESS=$(ip link show $GET_DEFAULT_INTERFACE | awk '/ether/ {print $2}')

# capture vendor MAC address
GET_VENDOR_MAC=$(ethtool -P $GET_DEFAULT_INTERFACE | awk '{print $3}')

# reset mac address if not equal to hardware specific vendor mac address
if [[ $GET_MAC_ADDRESS == $GET_VENDOR_MAC ]];
then
    echo "MAC address has not been modified, no change will take place."
    exit 0
else    
    # shut interface
    sudo ip link set dev $GET_DEFAULT_INTERFACE down
    # apply new MAC address
    sudo ip link set dev $GET_DEFAULT_INTERFACE address $GET_VENDOR_MAC
    # start interface
    sudo ip link set dev $GET_DEFAULT_INTERFACE up
    
    NEW_MAC_ADDRESS=$(sudo ip link show $GET_DEFAULT_INTERFACE | awk '/ether/ {print $2}')
    
    echo "MAC addresses resetted to: $NEW_MAC_ADDRESS" 
fi
