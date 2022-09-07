#!/usr/bin/env bash

apk --update --no-cache add busybox-extras
sudo telnetd -p 23 -b "$(/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1)" -l "admin" &