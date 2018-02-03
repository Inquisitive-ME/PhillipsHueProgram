
#!/abin/bash
rfcomm connect 0 CC:2D:B7:7C:F0:2B 10>/dev/null &
echo hcitool rssi CC:2D:B7:7C:F0:2B

#curl -H "Accept: application/json" -X PUT --data '{"on":true}' http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/action
