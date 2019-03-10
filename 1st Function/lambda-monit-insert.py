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

def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()

def main(event,context):
    result = []
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    time = now.strftime("%Y-%m-%d %H:%M")
    rtime = now.strftime("%H")
    dately = json.dumps(event['ttime'], default = myconverter)
    data = (event['name'], event['urgency'],event['host'], event['type'], event['ttime'], event['rtime'])
    add = ("INSERT INTO alerttrigger "
              "(name, urgency, host, type, ttime, htime) "
              "VALUES (%s, %s, %s, %s, %s, %s)")
    with conn.cursor() as cur:
        cur.execute(add,data)
        cur.execute("select * from alerttrigger")
        conn.commit()
        cur.close()
        for row in cur:
            result.append(list(row))
        print "Data from RDS..."
        print result
        print time
