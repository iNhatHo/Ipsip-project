#!/bin/sh

curl -vvv -XPOST https://h2kgcp144d.execute-api.us-east-2.amazonaws.com/Testing-v1 \
  -H 'Content-Type: application/json' \
  -d '{
      "name": "CPU error",
      "host": "inhatho-surface",
      "type": "Trigger",
      "urgency": "High"
      }' > /tmp/monit.log
