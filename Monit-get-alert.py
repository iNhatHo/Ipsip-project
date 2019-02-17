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
        cur.execute("select ttime,id,name,type,urgency,host from test ")
        conn.commit()
        cur.close()
        for row in cur:
            result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
    final = json.dumps(result, default = myconverter)
    new = final.replace('\"','')
    return (new)
    








# event = {
#   "id": 777,
#   "name": "appychip"
# }
# context = ""
# main(event, context)
