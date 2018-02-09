#!/bin/bash

readonly RichardPhoneMAC=CC:2D:B7:7C:F0:2B

DetectPhone()
{
	echo $1
	PingStatus=0
	NotConnected=0
	for ((i=1;i <= 5;i++)){
		sudo hcitool cc $1 2>/dev/null

		bt="$(hcitool rssi $1 | grep -o [0-9]*)"
		if [ -z "$bt" ]; then
			echo "NotConnected", "$NotConnected"
			NotConnected=$(($NotConnected+1))
		else
			bt=$(($bt+0))
			((PingStatus+=$bt))
			echo "$bt", "$PingStatus"
		fi
	}

	if [ $PingStatus -le 5 ] && [ $NotConnected -lt 2 ]; then
		PhoneStatus=1
	elif [ $PingStatus -ge 95 ] || [ $NotConnected -ge 2 ]; then
		PhoneStatus=0
	fi
}

GetLightStatus()
{
	LightsResponse="$(curl -H "Accept: application/json" -X GET http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/ | grep -oP '("all_on":).{0,4}')" >/dev/null
	if [ "$LightsResponse" == "\"all_on\":true" ]; then
		LightStatus=1
	elif [ "$LightsResponse" == "\"all_on\":fals" ]; then
		LightStatus=0
	else
		LightStatus=-1
		echo $LightsResponse
	fi
}

echo "START"
while true; do
DetectPhone $RichardPhoneMAC
echo PhoneStatus $PhoneStatus
GetLightStatus
echo LightStatus $LightStatus

if [ $LightStatus == 0 ] && [ $PhoneStatus == 1 ]; then
	echo ON
	curl -H "Accept: application/json" -X PUT --data '{"on":true}' http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/action > /dev/null
elif [ $LightStatus == 1 ] && [ $PhoneStatus == 0 ]; then
	echo OFF
	curl -H "Accept: application/json" -X PUT --data '{"on":false}' http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/action > /dev/null
fi
sleep 0.5
done


