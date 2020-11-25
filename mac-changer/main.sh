#!/bin/bash

GET_DEFAULT_INTERFACE=`route | grep '^default' | grep -o '[^ ]*$'`

GET_MAC_ADDRESS=`ip link show $GET_DEFAULT_INTERFACE | awk '/ether/ {print $2}'`

echo "Current MAC address in use: |$GET_MAC_ADDRESS|" \

if [[ ! -z $GET_MAC_ADDRESS ]];
then
    # generate a random mac address
    GENERATE_RANDOM_MAC=`sudo openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'`
    echo "Random MAC address: |$GENERATE_RANDOM_MAC|" \ 
    
    if [[ $GET_MAC_ADDRESS == $GENERATE_RANDOM_MAC ]];
    then
        echo "MAC address identical to new address, closing application..."
        sleep 2
        exit 0
    else
        # temporarily disable interface to avoid error message
        sudo ip link set dev $GET_DEFAULT_INTERFACE down
        # apply newly generated mac address
        sudo ip link set dev "$GET_DEFAULT_INTERFACE" address $GENERATE_RANDOM_MAC
        # enable interface
        sudo ip link set dev "$GET_DEFAULT_INTERFACE" up

        GET_NEW_INTERFACE_MAC=`ip link show $GET_DEFAULT_INTERFACE | awk '/ether/ {print $2}'`
        
        echo "Applying random MAC address |$GET_NEW_INTERFACE_MAC| to interface ($GET_DEFAULT_INTERFACE)"
    fi
fi

