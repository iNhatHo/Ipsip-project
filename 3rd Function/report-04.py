# A lambda function to interact with AWS RDS MySQL
import logging
import boto3
import pymysql
import sys
import json
import datetime

REGION = 'us-east-1'

rds_host  = "appychip.cae99tn0ffoc.us-east-1.rds.amazonaws.com"
name = "appychip"
password = "12345678"
db_name = "appychip"

def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()

def main(event,context):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    result = []
    timebegin =event.get('timebegin','2000-01-01')
    timeend =event.get('timeend','2000-01-01')
    with conn.cursor() as cur:
        cur.execute("select distinct name, host, ttime, rtime from alerttrigger where ttime > %s and ttime < %s group by name,host order by timediff(ttime,rtime) LIMIT 3",(timebegin,timeend))
        conn.commit()
        cur.close()
        for row in cur:
            result.append({'name': row[0], 'host': row[1],'ttime': row[2],'rtime':row[3]})
    o = json.dumps(result, default = myconverter)
    new = json.loads(o)
    print datetime.datetime.now()
    return (new)
