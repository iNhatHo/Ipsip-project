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
        cur.execute("select ai.name,ai.host,ai.info,ai.timein,ai.person,ai.type,a.tooltouse from alertinfo as ai, alert as a where ai.name =a.name and ai.host = a.host")
        conn.commit()
        cur.close()
        for row in cur:
            result.append({'name': row[0], 'host': row[1], 'info': row[2],'timein': row[3], 'person': row[4], 'type': row[5],'tooltouse': row[6]})
    o = json.dumps(result, default = myconverter)
    new = json.loads(o)
    return (new)
