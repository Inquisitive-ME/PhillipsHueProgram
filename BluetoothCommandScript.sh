#!/bin/bash

#sudo rfcomm connect 0 CC:2D:B7:7C:F0:2B 10>/dev/null &
#sleep 0.5
#hcitool rssi CC:2D:B7:7C:F0:2B
while true; do
sudo hcitool cc CC:2D:B7:7C:F0:2B 2>/dev/null

bt="$(hcitool rssi CC:2D:B7:7C:F0:2B | grep -o [0-9]*)"
bt=$(($bt+0))
if [ "$bt">=0 ]; then
	echo "$bt"
else
	echo "No Connected."
	echo "$bt"
fi
sleep 0.5
done

if [curl -H "Accept: application/json" -X http://192.168.99.27/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups
if [date +%H >19]
#curl -H "Accept: application/json" -X PUT --data '{"on":true}' http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/action
