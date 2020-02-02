#!/bin/bash

#define_passwd
passwd=sanuki

define_vncpasswd=$(expect -c "
set timeout 10
spawn vncpasswd

expect \"Password:\"
send \"${passwd}\r\"

expect \"Verify:\"
send \"${passwd}\r\"

expect \"Would you like to enter a view-only password (y/n)?\"
send \"n\r\"

expect eof
")

