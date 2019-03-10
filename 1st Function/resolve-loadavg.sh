#!/bin/sh
date=$(date '+%Y-%m-%d-%H:%M:%S')
hour=$(date '+%H')
curl -vvv -XPOST https://h2kgcp144d.execute-api.us-east-2.amazonaws.com/Testing-midterm/rds-update-alert-trigger \
  -H 'Content-Type: application/json' \
  -d '{
      "name": "Loadavg error",
      "host": "inhatho-surface",
	  "time": "'$date'"
      }' > /tmp/monit.log
