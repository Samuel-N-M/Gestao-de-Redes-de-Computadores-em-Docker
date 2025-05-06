#!/bin/bash
service bind9 start
tail -f /var/log/syslog
