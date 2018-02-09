##Getting Phillips Hue setup:

Source: https://developers.meethue.com/documentation/getting-started

1. Get the i.p. address of the bridge
	* I found mine through the IPhone app: 192.168.1.27

2. Go to http://<bridge ip address>/debug/clip.html

3. Next you need to get a user name from the bridge. This will be done by sending:
Address: http://<bridge ip address>/api
Body: {"devicetype":"<NAME_OF_DEVICE"}
Method: Post
Before posting you must hit the link button on your bridge. This is a security measure.

My username is:
"TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I"

4. Now I can use this username to get information or send commands to the bridge

**Example:**

- I can send the following to get all the lights on the bridge and their status:
Address: http://<bridge_ip_address>/api/<username>/lights
Body:
Method: Get

- then I can command one of these lights on by sending the following:
Address: http://<bridge_ip_address>/api/<username>/lights/<lightnumber>/state
Body:{"on":true}
Method: PUT

##Comand Line
The first step I took to writing a program to send messages to the phillips hue bulbs was to use the command line to send the messages

To do this I used the curl command
curl -H "Accept: application/json" -X PUT --data '{"on":true}' http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/action

##C Program
Next I wanted to write my program in C as my main goal right now is to become much better at C and C++

So all the documentation is on their website:
https://curl.haxx.se/

What we want is libcurl and they have ahttp://thread.gmane.org/gmane.linux.bluez.kernel/32517 pretty good tutorial, but it is a little hard if you have no idea what you are doing, so I complemented their resources and tutorials with googling quesitons

https://curl.haxx.se/libcurl/c/libcurl-tutorial.html

Start by installing libcurl, you can either download it form the site and compile it or on Ubuntu you can just do a sudo apt-get install Don't rember what the program is

make sure can compile a program that include curl/curl.h:
'#include <curl/curl.h\>'

###Initial Program
I followed the example program found  in this stack overflow answer:
https://stackoverflow.com/questions/42758926/curl-to-libcurl-http-put-request-in-json-format

```c
//PUT Request
#include <stdio.h>
#include <string.h>
#include <curl/curl.h>

int main(int argc, char const *argv[]){
CURL *curl;
CURLcode res;
long http_code;
static const char *jsonObj = //insert json here

curl = curl_easy_init();
curl_global_init(CURL_GLOBAL_ALL);

if(curl){

    curl_easy_setopt(curl, CURLOPT_URL, "//insert your url here");
    curl_easy_setopt(curl, CURLOPT_HTTPAUTH, (long)CURLAUTH_BASIC);
    curl_easy_setopt(curl, CURLOPT_USERPWD, "root:");

    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PUT");
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonObj);
```

including the libraries and creating the variables is straight forward

starting with the curl_global_init(). From the documentation it does not seem like this is needed and the curl_easy_init() will call a global init anyways **Double Check and Better Document**

I then just needed to use curl_easy_setop() to configure the http put message.

CURLOPT_URL sets the URl to send the request to

CUROPT_POSTFIELDS sets the data, but if I do not use the customrequest it uses a POST request which the gateway will not accept so I had to set a custom request to make it a get request. I think I can use the UPLOAD to do this but I need to experiement

I have not looked into getting the response of the request into a variable, but it does print the response on the command line when running the program.

    
Next steps:
Use curl_easy_setopt()
- setup to use http put and json
- try commanding lights on/off

##Bluetooth
Need to install Bluez libraries to compile
sudo apt-get install bluez libbluetooth-dev

build in gcc with -lbluetooth i.e.  gcc BluetoothTest.c -lbluetooth -o bluetooth 

https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/tools/hcitool.c

trying to compile hcitool.c
gcc hcitool.c -lbluetooth -o hcitool

I am getting a src/oui.h: No such file or directory
I'm not sure if this is needed for using Bluetooth, but when I remove it I get a bunch of undefined references to functions such as "undefined reference to \`hci_le_clear_resolving_list\' /tmp/ccYTltlI.o: In function `cmd_lerlsz':"

I'm not sure how to get the hcitool.c file to compile so I'm giving up, and was able to get the simplescan.c file to compile from the following webpage:
https://people.csail.mit.edu/albert/bluez-intro/c404.html#simplescan.c

I'm going to try to start with simplescan.c and hack in using hci tool to use the cc command and the rrsi command that I am using in bash scripts to bing my phone

I'm going to take a break now from the c program and see if I can get a bash program going to get something that works, as I feel I have not been making much progress

Then I need to figure out how to ping bluetooth in C currently using shell script:
'while true; do
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
'
```
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

```





