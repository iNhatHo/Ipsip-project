# A lambda function to interact with AWS RDS MySQL
import logging
import boto3
import pymysql
import sys
import json
import datetime

REGION = 'us-east-1'

rds_host  = "appychip.cqjqjnza85a5.us-east-1.rds.amazonaws.com"
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
        cur.execute("select * from test")
        conn.commit()
        cur.close()
        for row in cur:
            result.append({'id': row[0],'aname': row[1],'type': row[2],'host': row[3]})
    return (result)
    





# event = {
#   "id": 777,
#   "name": "appychip"
# }
# context = ""
# main(event, context)
