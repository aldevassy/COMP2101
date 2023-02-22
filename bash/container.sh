#!/bin/bash
#
#1 - Checking if the lxd is installed or not
which lxd >/dev/null
if [ $? -ne 0 ]; then
        echo "Installing lxd, wait untill it is installed :-)"
        sudo snap install lxd
        if [ $? -ne 0 ]; then
        #if it cannot installed, error message!!
                echo "failed to install lxd, sorry :-("
                exit 1
                fi
        #Confirmation that lxd is ready
        else
                echo "lxd is installled sucessfully"    
fi
#
#2 - On the hosting VM, run lxd init --auto if no lxdbr0 interface exists

if ! ip addr show lxdbr0 > /dev/null 2>&1; then
    echo "lxdbr0 interface does not exist, running lxd init"
    sudo lxd init --auto
fi
#
#3 checking the container and installing if it is needed
lxc list | grep -q COMP2101-S22
if [ $? = 0 ]; then 
        echo "container COMP2101-S22 status Confirmed :-)"
else
        lxc launch ubuntu:22.04 COMP2101-S22
        echo "container COMP2101-S22 has been sucessfully created"
fi
#
#4 . Gettng contaner IP addresses
ipaddress=$(lxc list | grep COMP2101-S2 | awk '{print $6}')
echo "Container IP address                      -" $ipaddress
#
#Installing apacche2 if it is necessary and checking the status
lxc exec COMP2101-S22 sudo apt install apache2 -q
if [ $? = 0 ]; then 
        echo "Apache2 is install status + Complete"
else
        echo "Failed to install apache2"
fi
#checking the status
lxc exec COMP2101-S22 sudo service apache2 status -q | grep Active -q #&& exit
if [ $? = 0 ]; then 
        echo "Apache2 is running inside COMP2101-S22 container- Confirmed"
else
        echo "Apache2 is not active inside the container"
fi
#
if curl http://COMP2101-S22 > /dev/null 2>&1; then
    echo "SUCCESS: Container web service is accessible"
else
    echo "FAILURE: Could not access container web service"
fi

