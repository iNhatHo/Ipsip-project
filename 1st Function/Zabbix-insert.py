import boto3
import json
import sys
import logging
import pymysql
from dateutil import parser
import datetime
now = datetime.datetime.now()

REGION = 'us-east-1'

rds_host  = "appychip.cae99tn0ffoc.us-east-1.rds.amazonaws.com"
name = "appychip"
password = "12345678"
db_name = "appychip" 

def main(event,context):
    result = []
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    alertsubject = event['subject']
    alertname = event['message']['name']
    host = event['message']['host']
    urgency = event['message']['urgency']
    type = event['message']['type']
    ttime = event['message']['ttime']
    if event['message']['type'] == "PROBLEM":
        typee = "Trigger"
    if event['message']['type'] == "OK":
        typee = "Resolve"
    print typee
    print event['message']['type']
    timedb= parser.parse(ttime)
    print event['message']['ttime']
    with conn.cursor() as cur:
        cur.execute("insert into alerttrigger(name, host, urgency, type, ttime) values (%s, %s, %s, %s, %s)",(alertname,host,urgency,typee, timedb))
        cur.execute("select * from alerttrigger")
        conn.commit()
        cur.close()
        for row in cur:
            result.append(list(row))
        print "Data from RDS..."
        print result
    message = {}
    message['host'] = host
    message['name'] = alertname
    message['urgency'] = urgency
    message['type'] = typee
    sns = boto3.client('sns')
    if 'PROBLEM' in alertsubject:
        sns.publish(
            TopicArn = 'arn:aws:sns:us-east-2:907745474917:zabbix',
            Subject = 'Trigger Alert: ' + alertsubject,
            Message = json.dumps(message)
        )
    return ('Sent a message to an Amazon SNS topic.')
