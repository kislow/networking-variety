#!/usr/bin/expect -f

# Set variables
set hostname [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set enablepassword [lindex $argv 3]
set date [exec date +%F]


# Log results
log_file -a /var/log/backup/backup-$date.log

# Announce device & time
send_user "\n"
send_user ">>>>> Working on $hostname @ [exec date] <<<<<\n"
send_user "\n"

# Don't check keys
spawn ssh -o StrictHostKeyChecking=no $username\@$hostname

# Connection issues & priv password
expect {
timeout { send_user "\nTimeout Exceeded - Check Host\n"; exit 1 }
eof { send_user "\nSSH Connection To $hostname Failed\n"; exit 1 }
"*assword:" { send "$password\r" }
}

# Enable password
expect {
default { send_user "\nLogin Failed - Check Password\n"; exit 1 }
"*#" { send "\r" }
"*>" {
send "enable\n"
expect "*assword:"
send "$enablepassword\r"
}
}

# Backup config to tftp server
expect {
"*#" { 
send "copy running-config tftp:\r" 
expect {
"Enter destination filename:*" {
send "\r"
expect "(If no input, current vrf 'default' is considered): "
send "\r"
expect "*server:"
send "$server\r"
expect "*(please wait)..."
send "exit\r" 
}
"Address or name of remote host []?*" {
send "$server\r"
expect "*filename*"
send "\r"
expect "*copied*"
send "exit\r" 
}
}
}
}
