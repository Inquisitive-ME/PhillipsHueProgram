
#!/bin/bash

read -p 'Lights "ON" or "OFF"' LightStatus
echo 
echo $LightStatus
echo

if [ "$LightStatus" == "ON" ] || [ "$LightStatus" == "on" ] || [ "$LightStatus" == "On" ]; then
	curl -H "Accept: application/json" -X PUT --data '{"on":true}' http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/action > /dev/null
elif [ "$LightStatus" == "OFF" ] || [ "$LightStatus" = "off" ] || [ "$LightStatus" == "Off" ]; then
	curl -H "Accept: application/json" -X PUT --data '{"on":false}' http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/action > /dev/null
else
	./HueCommandScript.sh
fi

test="$(curl -H "Accept: application/json" -X GET http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/ | grep -oP '("all_on":).{0,4}')" >/dev/null

if [ "$test" == "\"all_on\":true" ]; then
	echo $test
fi



