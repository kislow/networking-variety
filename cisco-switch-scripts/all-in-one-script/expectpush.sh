#!/usr/bin/expect -f

# Set variables
set hostname [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set enablepassword [lindex $argv 3]
set privatekey [lindex $argv 4]
set date [exec date +%F]
set m 0

# Log results
#log_file -a /var/log/backup/backup-$date.log

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

foreach arg $argv {
	if { $m >= 5 } then { eval $arg }
	incr m
}

}
}
