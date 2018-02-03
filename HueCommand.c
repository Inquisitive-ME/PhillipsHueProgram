#include <stdio.h>
#include <string.h>
#include <curl/curl.h>


int main(void){
	printf("HELLO WORLD\n");
	CURL *curl;
	CURLcode res;
	long http_code;
	static const char *jsonObj = "{\"on\":true}";// insert json here
	printf("%s\n",jsonObj);
	printf("%d",strlen(jsonObj));

	curl_global_init(CURL_GLOBAL_ALL);
	curl = curl_easy_init();
	if(curl){
		curl_easy_setopt(curl,CURLOPT_URL,"http://192.168.99.27/api/TupfOmPqTaiMkujwG-nwUzScxnC3Chubz9ys3Q5I/groups/1/action");

		curl_easy_setopt(curl,CURLOPT_POSTFIELDSIZE,12L);
		curl_easy_setopt(curl,CURLOPT_POSTFIELDS,jsonObj);
		curl_easy_setopt(curl,CURLOPT_CUSTOMREQUEST,"PUT");

		curl_easy_perform(curl);

	}

	curl_easy_cleanup(curl);

	return 1;
}

//curl -H "Accept: application/json" -X PUT --data '{"on":true}' 

