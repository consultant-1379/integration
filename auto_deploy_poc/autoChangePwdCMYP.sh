#!/usr/bin/expect

set timeout 3
set NODE_IP [lindex $argv 0]
set YANG_PORT [lindex $argv 1]
spawn ssh admin@$NODE_IP -p $YANG_PORT
expect "*Password*"
send "!Eri3CsSo4n1\r"
expect "*New password:"
send "EricSson@12-34\r"
expect "Retype new password:"
send "EricSson@12-34\r"
sleep 30
expect eof

