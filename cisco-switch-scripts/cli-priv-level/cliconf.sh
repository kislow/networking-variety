#!/usr/bin/expect -f

# cisco switch script to define privilege levels for specific radius groups

# Set variables
set hostname [lindex $argv 0]
set username "username"
set password "password"
set date [exec date +%F]


# Log results
log_file -a /var/log/cisco/config-$date.log

# Announce device & time
send_user "\n"
send_user ">>>>> Working on $hostname @ [exec date] <<<<<\n"
send_user "\n"

# Don't check keys
spawn ssh -o StrictHostKeyChecking=no $username@$hostname
expect "*assword: "
send -- "$password\r"


# configuration changes
expect {
"*>" {
send "en\r"
expect "*#" 
send "configure terminal\r"
expect "*config)#"
send "aaa authentication login default local group radius\r"
send "aaa authorization exec default local group radius\r"
send "privilege exec level 7 configure terminal\r"
send "privilege exec level 7 show running interface\r"
send "privilege configure level 7 interface\r"
send "privilege interface level 7 spanning-tree bpduguard\r"
send "privilege interface level 7 spanning-tree portfast trunk\r"
send "privilege interface level 7 spanning-tree portfast disable\r"
send "privilege interface level 7 spanning-tree portfast\r"
send "privilege interface level 7 spanning-tree\r"
send "privilege interface level 7 dot1x\r"
send "privilege interface level 7 mab\r"
send "privilege interface level 7 authentication\r"
send "privilege interface level 7 udld\r"
send "privilege interface level 7 speed\r"
send "privilege interface level 7 switchport\r"
send "privilege interface level 7 description\r"
send "line vty 0 4\r"
expect "*config-line)#"
send "authorization exec default\r"
send "login authentication default\r"
send "exit\r"
expect "*config)#"
send "end\r"
expect "*#"
send "wr mem\r"
send "exit\r"
}
}


