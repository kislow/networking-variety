#!/usr/bin/expect -f

# This script can be beneficial for a large scale of cisco switches with similiar configs. 
# Configure one swtich, make a backup of the bin file and use this script to push the binfile to multiple switches


# Set variables
set hostname [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set enablepassword [lindex $argv 3]
set date [exec date +%F]

# Log results
log_file -a /var/log/cisco_conf/config-$date.log

# Announce device & time
send_user "\n"
send_user ">>>>> Working on $hostname @ [exec date] <<<<<\n"
send_user "\n"

# Don't check keys (best to enable keys in production)
spawn ssh -o StrictHostKeyChecking=no $username\@$hostname

# Connection issues & priv password
expect {
timeout { send_user "\nTimeout Exceeded - Check Host\n"; exit 1 }
eof { send_user "\nSSH Connection To $hostname Failed\n"; exit 1 }
"*assword:" { send "$password\r" }
}

#--- uncomment section below if "Enable password" is in place ---#

# Enable password
#expect {
#default { send_user "\nLogin Failed - Check Password\n"; exit 1 }
#"*#" { send "\r" }
#"*>" {
#send "enable\n"
#expect "*assword:"
#send "$enablepassword\r"
#}
#}

#-----------------------------------------------------------------#

# copies cisco image from tftp server to cisco flash and saves it
expect {
"*#" { 
send "copy tftp://10.0.0.10/switchName-universalk9-mz.152-4.E3.bin flash:\r"
expect "*Destination filename [switchName-universalk9-mz.152-4.E3.bin]?"
send "\r"
expect "*Accessing tftp://10.0.0.10/switchName-universalk9-mz.152-4.E3.bin..."
send "\r"
expect "*#"
send "copy run start\r"
expect "*(please wait)..."
send "exit\r"
}
}


