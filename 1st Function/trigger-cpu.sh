#!/bin/sh
date=$(date '+%Y-%m-%d-%H:%M:%S')
hour=$(date '+%H')
curl -vvv -XPOST https://h2kgcp144d.execute-api.us-east-2.amazonaws.com/Testing-midterm/rds-insert-alert-trigger \
  -H 'Content-Type: application/json' \
  -d '{
      "name": "CPU error",
      "host": "inhatho-surface",
      "type": "Trigger",
	  "ttime": "'$date'",
	  "rtime": "'$hour'",
      "urgency": "High"
      }' > /tmp/monit.log
