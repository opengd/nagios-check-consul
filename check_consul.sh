#!/bin/bash
#COMMAND="check_consul $1"

aa=$(curl -s $1)

if [ -z "$aa" ] || [ "$aa" == "[]" ]
then
        MESSAGE="CRITICAL - Could not retrieve json data from url"
	STATUS=2
else
	curl -s $1 | jq '.[].Checks[0] | "\(.Status) \(.Node)"' | awk '{rows++} {print $0} $0~"passing" {passing++} END {if(passing==rows) {exit 0} else {exit 2}}'
	STATUS=$?
	if [ $STATUS -eq 0 ]
	then
		MESSAGE="OK - all is passing"
	else
		MESSAGE="CRITICAL - check any not passing consuls"
	fi
	
fi

printf "$MESSAGE"
exit $STATUS
