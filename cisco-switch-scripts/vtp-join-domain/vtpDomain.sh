#!/usr/bin/expect -f

# Set variables
set hostname [lindex $argv 0]
set username "enter-username"
set password "enter-password"
set date [exec date +%F]


# Log results
log_file -a /var/script/cisco_config/vtp/log/config-$date.log

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
send "vtp mode client\r"
expect "*config)#"
send "vtp version 3\r"
expect "*config)#"
send "vtp domain domainName\r"
expect "*config)#"
send "vtp password EnterPassword hidden\r"
send "exit\r"
expect "*#"
send "wr mem\r"
send "exit\r"
}
}


