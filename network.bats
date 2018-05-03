#!/usr/bin/env bats

. network.sh

@test "is 192.168.0.1 greater then 10.0.10.1" {
    ip_gt 192.168.0.1 10.0.10.254
}

@test "is 10.0.10.1 NOT greater then 192.168.0.1" {
    ! ip_gt 10.0.10.1 192.168.0.1
}

@test "is 10.0.10.2 greater then 10.0.10.1" {
    ip_gt 10.0.10.2 10.0.10.1
}

@test "is 10.0.10.1 NOT greater then 10.0.10.2" {
    ! ip_gt 10.0.10.1 10.0.10.2
}

@test "is 192.168.0.1 in 192.168.0.0/24" {
    ip_in_subnet 192.168.0.1 192.168.0.0/24
}

@test "is 192.168.0.1 NOT in 10.0.10.0/16" {
    ! ip_in_subnet 192.168.0.1 10.0.10.0/24
}
