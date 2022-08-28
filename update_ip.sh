#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit 2
fi

ifconfig eth0 "$1" netmask 255.255.255.0