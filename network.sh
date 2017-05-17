#!/bin/bash

ip_gt(){
# check if one IPv4 address is greater than the other
# eg.: ip_gt 192.168.0.1 10.0.0.1

    ip1=( ${1//\./\ } )
    ip2=( ${2//\./\ } )

    result=2
    for octet in {0..3}; do
        if [ ${ip1[$octet]} -gt ${ip2[$octet]} ]; then
	    [ $result -eq 1 ] || result=0
        fi

        if [ ${ip1[$octet]} -lt ${ip2[$octet]} ]; then
	    [ $result -eq 0 ] || result=1
	fi
    done

    return $result
}

ip_in_subnet(){
# check if IPv4 address belongs to subnet
# e.g.: ip_in_subnet 192.168.0.1 192.168.0.0/24

    ip=$1
    subnet=$2

    export $(ipcalc -n $subnet)
    export $(ipcalc -b $subnet)

    if ip_gt $ip $NETWORK && ! ip_gt $ip $BROADCAST; then
        return 0
    fi

    return 1
}

my_ip(){
# print IPv4 address on Linux machine that is used to access the default route
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
