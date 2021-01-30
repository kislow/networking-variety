#!/bin/bash

DEFAULT_INTERFACE=$(route | grep '^default' | grep -o '[^ ]*$')
INTERFACE_OPTIONS=${1:-apply}

get_mac_address {
    local mac_address=$(ip link show $DEFAULT_INTERFACE | awk '/ether/ {print $2}')
    echo "$mac_address"
}

get_random_mac_address {
    local generate_mac_address=$(sudo openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
    echo "$generate_mac_address"
}

apply_mac_address {
    disable_int=$(sudo ip link set dev $DEFAULT_INTERFACE down)
    local random_mac=$(sudo ip link set dev $DEFAULT_INTERFACE address get_random_mac_address)
    enable_int=$(sudo ip link set dev $DEFAULT_INTERFACE up)
    echo "$disable_int"
    echo "$random_mac"
    echo "$enable_int"
}

reset_to_vendor_address {
    vendor_mac=$(ethtool -P $DEFAULT_INTERFACE | awk '{print $3}')
    local reset_mac=$(sudo ip link set dev $DEFAULT_INTERFACE address $vendor_mac)
    echo "$disable_int"
    echo "$reset_mac"
    echo "$enable_int"
}

get_new_interface_mac_address {
    new_mac_address=$(ip link show $default_interface | awk '/ether/ {print $2}')
    echo "$new_mac_address"
}

echo "Current MAC address in use: " get_mac_address


if [[ $INTERFACE_OPTIONS == "apply" ]];
then
    echo "Generating random mac address: " get_random_mac_address
    if [[ get_mac_address == get_random_mac_address ]];
    then
        echo "MAC address identical to new address, closing application..."
        sleep 1
        exit 0
    else
        apply_mac_address
        echo "Applying random mac address..."
        get_new_interface_mac_address
    fi
else if [[ $INTERFACE_OPTIONS == "reset" ]];
then
    if [[ $vendor_mac == get_mac_address ]];
    then
        echo "No reset of mac address necessary, closing application..."
        sleep 1
        exit 0
    else 
        echo "Resetting to vendor mac address..."
        reset_to_vendor_address
fi
