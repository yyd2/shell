#!/bin/bash

Java_Port(){

URL='http://127.0.0.1:'
URI='/actuator/prometheus'

PORT=`ss -nlpt |grep java|awk {'print $4'} |awk -F: {'print $4'}`

for n in $PORT
do
	curl $URL$n$URI &> /dev/null
 	if [ $? -eq 0 ]
	then 
		echo "Request is completed"	
	else
		echo "The request failed"
	fi
done
touch 1111
(echo "5 0 * * * bash /root/shell/java.sh > /dev/null 2>&1 ") | crontab



}
Java_Port
