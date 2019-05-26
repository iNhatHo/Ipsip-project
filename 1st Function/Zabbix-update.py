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
    rtime = event['message']['rtime']
    alertname = event['message']['name']
    host = event['message']['host']
    timedb= parser.parse(rtime)
    print event['message']['rtime']
    with conn.cursor() as cur:
        cur.execute("""Update alerttrigger SET type = 'Resolve', rtime = %s where name = %s and host = %s and type = 'Trigger'""", (timedb, alertname, host))
        cur.execute("select * from alerttrigger")
        conn.commit()
        cur.close()
        for row in cur:
            result.append(list(row))
        print "Data from RDS..."
        print result
