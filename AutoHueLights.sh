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
		bt=$(($bt+0))
		((PingStatus+=$bt))
		if [ "$bt">=0 ]; then
			end=$(($(date +%s%N)/1000000))
			echo "$bt", "$PingStatus"
		else
			echo "NotConnected","$bt"
			NotConnected=$(($NotConnected+0))
		fi
}


echo "START"
DetectPhone RichardPhoneMAC
echo "END"

