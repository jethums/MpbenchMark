#!/bin/bash

#echo 26 > /sys/class/gpio/export
#echo out > /sys/class/gpio/gpio26/direction

count=1

echo 1 > /sys/class/gpio/gpio26/value
while [ $count -le 100 ]; do
    #echo 1 > /sys/class/gpio/gpio26/value
    java mpbenchmark
    #echo 0 > /sys/class/gpio/gpio26/value
    count=$((count + 1))
done
echo 0 > /sys/class/gpio/gpio26/value
