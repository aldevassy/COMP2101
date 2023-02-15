#!/bin/bash

#hostname and FQDN
hostname=$(hostname)
fqdn=$(hostname -f)

#OS name and version
os_info=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d '"' -f 2)

# display IP address
ip_address=$(ip route get 8.8.8.8 | awk 'NR==1 {print $7}')

#To display IP addresses the machine has that are not on the 127 network
#ip_address=$(ip addr | grep -v "127" | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | tr '\n' ' ')

#Root filesystem free space
root_space=$(df -h / | awk 'NR==2 { print $4 }') 
cat <<EOF

Hostname: $hostname

--------------------------------------------------
--------------------------------------------------
Fully Qualified Domain Name: $fqdn
Operating System: $os_info
Default Route IP: $ip_address
Root Filesystem Free Space: $root_space
--------------------------------------------------
--------------------------------------------------
EOF






