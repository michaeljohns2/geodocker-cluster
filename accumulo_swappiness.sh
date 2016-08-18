#! /usr/bin/env bash

#<<<run as privileged>>>

echo "...swappiness value prior? $(cat /proc/sys/vm/swappiness)"
sysctl vm.swappiness=10

echo "...swappiness value after (expect 10)? $(cat /proc/sys/vm/swappiness)"
echo "...you can add value 'vm.swappiness=10' to '/etc/sysctl.conf' to make permanent."


