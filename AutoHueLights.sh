#!/bin/bash

readonly RichardPhoneMAC=CC:2D:B7:7C:F0:2B

DetectPhone()
{
	echo $1
	PingStatus=0
	NotConnected=0
	pings=0
	for ((i=1;i <= 5;i++)){
		sudo hcitool cc $1 2>/dev/null
		sleep 0.5
		bt="$(hcitool rssi $1 | grep -o [0-9]*)"
		if [ -z "$bt" ]; then
			echo "NotConnected", "$NotConnected"
			NotConnected=$(($NotConnected+1))
		else
			bt=$(($bt+0))
			((PingStatus+=$bt))
			((pings+=1))
			echo "$bt", "$PingStatus"
		fi
	}
	if [ "$pings" == "0" ]; then
		pings=1
	fi
	#echo test $(($PingStatus / $pings))
	if [ $(($PingStatus/$pings)) -le 2 ] && [ $NotConnected -le 2 ]; then
		PhoneStatus=1
	elif [ $(($PingStatus/$pings)) -ge 12 ] || [ $NotConnected -ge 5 ]; then
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
GetLightStatus
previousLightStatus=$LightStatus
manual = 0
while true; do
DetectPhone $RichardPhoneMAC
echo PhoneStatus $PhoneStatus
GetLightStatus
echo LightStatus $LightStatus

if [ "$LightStatus" != "$previousLightStatus" ]; then
	manual=1
fi

echo manual $manual

if [ "$manual" == "1" ] && [ "$PhoneStatus" == "1" ]; then
	previousLightStatus=$LightStatus
elif [ "$manual" == "1" ] && [ "$PhoneStatus" == "0" ]; then
	echo change manual
	manual=0
	curl -H "Accept: application/json" -X PUT --data '{"on":false}' http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/action > /dev/null
	previousLightStatus=0
elif [ "$LightStatus" == "0" ] && [ "$PhoneStatus" == "1" ]; then
	echo ON
	curl -H "Accept: application/json" -X PUT --data '{"on":true}' http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/action > /dev/null
	previousLightStatus=1
elif [ "$LightStatus" == "1" ] && [ "$PhoneStatus" == "0" ]; then
	echo OFF
	curl -H "Accept: application/json" -X PUT --data '{"on":false}' http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/action > /dev/null
	previousLightStatus=0
else
	previousLightStatus=$LightStatus
fi

sleep 1
done
