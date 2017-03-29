#!/bin/bash
/opt/spark/sbin/start-thriftserver.sh $@

while :
do
	echo "Press [CTRL+C] to stop.."
	sleep 1
done
