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
        cur.execute("select timein, timeout, name, host, normalinfo, newinfo, personname,type from test1")
        conn.commit()
        cur.close()
        for row in cur:
            result.append({'timein': row[0], 'timeout': row[1], 'name': row[2],'host': row[3], 'normalinfo': row[4], 'newinfo': row[5], 'personname': row[6], 'type': row[7]})
    o = json.dumps(result, default = myconverter)
    new = json.loads(o)
    return (new)
    
 
