#!/bin/bash

ip_gt(){
# check if one IPv4 address is greater than another
# e.g.: ip_gt 192.168.0.1 10.0.0.1

    ip1=${1//\./}
    ip2=${2//\./}

    [ $ip1 -gt $ip2 ]
}

ip_in_subnet(){
# check if an IPv4 address belongs to a subnet
# e.g.: ip_in_subnet 192.168.0.1 192.168.0.0/24

    ip=$1
    subnet=$2

    eval $(ipcalc -n $subnet)
    eval $(ipcalc -b $subnet)

    ip_gt $ip $NETWORK && ! ip_gt $ip $BROADCAST
}

my_ip(){
# print an IPv4 address on a Linux machine that is used to access the default route
# e.g.: my_ip

    droute=$(ip ro | grep -Eo "default via [0-9\.]+" | cut -d' ' -f3)
    subnets=$(ip ro | grep -Eo ^[0-9\.\]+/[0-9]+)

    [ -z $droute ] && return 1

    for subnet in $subnets; do
        if ip_in_subnet $droute $subnet; then
            ip ro | grep $subnet | grep -Eo src\ [0-9\.]+ | cut -d' ' -f2
            break
        fi
    done
}
