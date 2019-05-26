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
    lid = event.get('id',"not")
    with conn.cursor() as cur:
        if lid == "not":
            return "Missing id"
        else:
            cur.execute("delete from alertinfo where id = %s", event['id'])
            conn.commit()
            cur.close()
            return "Action completed"
    



