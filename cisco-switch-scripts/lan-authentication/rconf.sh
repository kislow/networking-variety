#!/usr/bin/expect -f

# define variables
set hostname [lindex $argv 0]
set username "enter-username"
set password "enter-password"
set date [exec date +%F]


# define logging results destination
log_file -a /var/script/cisco_config/radius_switch_push/log/config-$date.log

# Announce device & time
send_user "\n"
send_user ">>>>> Working on $hostname @ [exec date] <<<<<\n"
send_user "\n"

# Don't check keys (enable check keys for production)
spawn ssh -o StrictHostKeyChecking=no $username@$hostname
expect "*assword: "
send -- "$password\r"


# setup cisco switch to enable 802.1x authentication and connect to radius
expect {
"*#" {
send "configure terminal\r"
expect "*config)#"
send "ip domain-name company.domain\r"
send "no ip domain-lookup\r"
send "no ip http server\r"
send "no ip http secure-server\r"
send "dot1x system-auth-control\r"
send "ip radius source-interface Vlan2\r"
send "aaa new-model\r"
send "aaa authentication login default local\r"
send "aaa authentication enable default none\r"
send "aaa authentication dot1x default group radius\r"
send "aaa authorization network default group radius\r"
send "aaa accounting dot1x default start-stop group radius\r"
send "aaa accounting update periodic 5\r"
send "aaa session-id common\r"
send "radius server radiusServerName\r"
expect "*config-radius-server)#"
send "address ipv4 10.0.0.10 auth-port 1812 acct-port 1813\r"
send "key EnterPassword\r"
send "exit\r"
expect "*config)#"
send "radius server radiusServerName2\r"
expect "*config-locsvr-da-radius)#"
send "address ipv4 10.0.0.20 auth-port 1812 acct-port 1813\r"
send "key EnterPassword\r"
send "exit\r"
send "radius-server vsa send accounting\r"
send "radius-server vsa send authentication\r"
send "radius-server attribute 6 on-for-login-auth\r"
send "radius-server attribute 8 include-in-access-req\r"
send "radius-server attribute 25 access-request include\r"
send "radius-server dead-criteria time 30 tries 3\r"
send "aaa server radius dynamic-author\r"
expect "*config-locsvr-da-radius)#"
send "client 10.0.0.10 server-key EnterPassword\r"
send "client 10.0.0.20 server-key EnterPassword\r"
send "exit\r"
expect "*config)#"
send "end\r"
expect "*#"
send "wr mem\r"
send "exit\r"
}
}


