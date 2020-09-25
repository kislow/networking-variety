#!/bin/bash

# Parse config.json
default_username=$(cat './config.json' | jq -r '.default.username')
default_sshkey=$(cat './config.json' | jq -r '.default.sshkey')

authentication_publickey_enable=$(cat './config.json' | jq -r '.authentication.publickey.enable')
authentication_publickey_filepath=$(cat './config.json' | jq -r '.authentication.publickey.filepath')
authentication_publickey_fallbackpassword=$(cat './config.json' | jq -r '.authentication.publickey.fallbackpassword')
authentication_enablepassword=$(cat './config.json' | jq -r '.authentication.enablepassword')


################################################################
##### Select switch family and model
### Family
echo "Select switch family."
echo "########## Select family"
cat './config.json' | jq -r '.switch | keys[]'
echo "########## Select family"
read -p "Value: " switchfamily 
printf "\n\n\n"

### Model
echo "Select switch model."
echo "########## Select model"
cat './config.json' | jq -r '.switch.'$switchfamily' | keys[]'
echo "########## Select model"
read -p "Value: " switchmodel
printf "\n\n\n"

### Show IPs
echo "IPs to connect:"
readarray -t switchlist <<< "$(cat './config.json' | jq -r '.switch.'$switchfamily'.'$switchmodel.ips' | values[]')"
echo ${switchlist[*]}
printf "\n\n\n"


################################################################
###### Collect username, ssh, & enable passwords
### Username
read -p "Enter username (default: $default_username): " user
user=${user:-$default_username}

### Publickey, if publickey auth is enabled
if [ $authentication_publickey_enable = "true" ]
then
	read -p "Enter SSH key filepath (default: $default_sshkey): " sshkey
	sshkey=${sshkey:-$default_sshkey}
fi

### SSH-Password if publickey is disabled or fallbackpassword enabled
if [ $authentication_publickey_enable = "false" ] || ([ $authentication_publickey_enable = "true" ] && [ $authentication_publickey_fallbackpassword = "true" ])
then
	printf "Enter SSH password: "
	read -s -e password
fi

### Enable-Password if enabled
if [ $authentication_enablepassword = "true" ]
then
	printf "Enter enable password: "
	read -s -e enable
fi
################################################################

# Open device list & send the collected information to script
for switch in ${switchlist[*]}; 
do
	./expectpush.sh $switch $user $password $enable $sshkey;
done
