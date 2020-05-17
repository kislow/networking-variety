#!/usr/bin/expect -f

# Set variables
set hostname [lindex $argv 0]
set username "username"
set password "password"
set date [exec date +%F]


# Log results
log_file -a /var/script/cisco_config/vtp/bau3/transparent_mode/log/config-$date.log

# Announce device & time
send_user "\n"
send_user ">>>>> Working on $hostname @ [exec date] <<<<<\n"
send_user "\n"

# Don't check keys
spawn ssh -o StrictHostKeyChecking=no $username@$hostname
expect "*assword: "
send -- "$password\r"
# to hide output use log_user 0

# configuration changes
expect {
"*>" {
send "en\r"
expect "*#"
send "configure terminal\r"
expect "*config)#"
send "vtp mode transparent\r"
expect "*config)#"
send "vtp domain NULL\r"
expect "*config)#"
send "no vtp password\r"
send "exit\r"
expect "*#"
send "wr mem\r"
send "exit\r"
}
}


