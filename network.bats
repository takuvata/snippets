#!/usr/bin/env bats

. network.sh

@test "is 192.168.0.1 greater then 10.0.10.1" {
    ip_gt 192.168.0.1 10.0.10.254
}

@test "is 192.168.0.1 NOT greater then 172.16.16.1" {
    ! ip_gt 192.168.0.1 172.16.16.1
}

@test "is 10.0.10.1 lesser then 192.168.0.1" {
    run ip_lt 192.168.0.1 10.0.10.254
}

@test "is 10.0.10.1 NOT lesser then 10.0.0.1" {
    ! ip_lt 10.0.10.1 10.0.0.1
}

@test "is 192.168.0.1 in 192.168.0.0/24" {
    run ip_in_subnet 192.168.0.1 192.168.0.0/24
}

@test "is 192.168.0.1 NOT in 192.168.1.0/24" {
    run ip_in_subnet 192.168.0.1 192.168.0.0/24
}
