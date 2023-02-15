#backup of lab1

#!/bin/bash

#To display fully-qualified domain name (FQDN)

echo "Domain name: $(hostname -f)"


#To display operating system name and version

echo "Host Information:" 
hostnamectl

#To display IP addresses the machine has that are not on the 127 network

echo "IP Addresses:$(ip addr | grep -v "127" | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | tr '\n' ' ')"

#To display the the amount of space available in only the root filesystem

echo "Space available: $(df -h / | tail -1 | awk '{print $4}')"
