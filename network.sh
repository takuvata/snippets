#!/bin/bash

ip_gt(){
    ip1=( ${1//\./\ } )
    ip2=( ${2//\./\ } )

    for octet in {0..3}; do
        [ ${ip1[$octet]} -lt ${ip2[$octet]} ] && return 1
    done
    return 0
}

ip_lt(){
    ip1=( ${1//\./\ } )
    ip2=( ${2//\./\ } )

    for octet in {0..3}; do
        [ ${ip1[$octet]} -gt ${ip2[$octet]} ] && return 1
    done

    return 0
}

ip_in_subnet(){
    ip=$1
    subnet=$2

    export $(ipcalc -n $subnet)
    export $(ipcalc -b $subnet)

    if ip_gt $ip $NETWORK && ip_lt $ip $BROADCAST; then
        return 0
    fi

    return 1
}

my_ip(){
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
