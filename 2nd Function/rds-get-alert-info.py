# A lambda function to interact with AWS RDS MySQL
import logging
import boto3
import pymysql
import sys
import json
import datetime
import time

REGION = 'us-east-1'

rds_host  = "appychip.cae99tn0ffoc.us-east-1.rds.amazonaws.com"
name = "appychip"
password = "12345678"
db_name = "appychip"

def myconverter(o):
    if isinstance(o, datetime.date):
        return o.__str__()

def main(event,context):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    result = []
    with conn.cursor() as cur:
        cur.execute("select ai.ID ,ai.name,ai.host,ai.info,ai.timein,ai.person,ai.type,a.tooltouse from alertinfo as ai, alert as a where ai.name =a.name and ai.host = a.host")
        conn.commit()
        cur.close()
        for row in cur:
            result.append({'id': row[0], 'name': row[1], 'host': row[2], 'info': row[3],'timein': row[4], 'person': row[5], 'type': row[6],'tooltouse': row[7]})
    o = json.dumps(result, default = myconverter)
    new = json.loads(o)
    return (new)
    
