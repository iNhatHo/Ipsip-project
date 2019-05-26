import logging
import boto3
import pymysql
import sys
import json
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
    time = now.strftime("%Y-%m-%d %H:%M")
    rtime = now.strftime("%H")
    with conn.cursor() as cur:
        cur.execute("""Update alerttrigger SET type = 'Resolve', rtime =%s where name =%s and host = %s and type = 'trigger'""", (event['time'],event['name'],event['host']))
        cur.execute("select * from alerttrigger ")
        conn.commit()
        cur.close()
        for row in cur:
            result.append(list(row))
        print "Data from RDS..."
        print result

