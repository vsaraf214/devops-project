#!/bin/bash

if [ $# -ne 1 ]
then
 printf "Invalid Arguments. Please pass URL to validate"
 exit 1
fi

printf $1 | grep https 
if [ $? -ne 0 ]
then
	printf "http url passed. test for redirection \n \n"
	curl -I $1 > /tmp/output

	grep "HTTP/1.1 301 Moved Permanently" /tmp/output  >/dev/null
	if [ $? -ne 0 ]
	then
		printf "Redirection test failed \n\n"
		exit 1
	else
		printf "Redirection Test Passsed \n\n"
		printf "Testing the redirected URL \n\n"
		URL=`grep Location /tmp/output | awk '{print $2}' | grep -v '%0D'`
		curl --insecure $URL | grep "Hello World" 
	        if [ $? -ne 0 ]
		then
			printf "Redirection test failed"
			exit 1
		else 
			printf "All tests passes"
			exit 0
		fi		
	fi
else
	printf "HTTPS secure URL passed. Testing the URL \n\n"
	curl --insecure $1 | grep "Hello World"
	if [ $? -ne 0 ]
                then
                        printf "Test failed"
                        exit 1
                else
                        printf "All tests passes"
                        exit 0
                fi

	
fi

 


