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
    with conn.cursor() as cur:
        cur.execute("select ttime,rtime,id,name,type,urgency,host from alerttrigger where type='Resolve' order by rtime desc")
        conn.commit()
        cur.close()
        for row in cur:
            result.append({'ttime': row[0],'rtime': row[1], 'id': row[2], 'name': row[3],'type': row[4], 'urgency': row[5],'host': row[6]})
    o = json.dumps(result, default = myconverter)
    new = json.loads(o)
    print datetime.datetime.now()
    return (new)
    
