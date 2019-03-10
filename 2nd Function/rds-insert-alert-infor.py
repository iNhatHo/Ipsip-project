import logging
import boto3
import pymysql
import sys
import json
import datetime
now=datetime.date.today()

REGION = 'us-east-1'

rds_host  = "appychip.cae99tn0ffoc.us-east-1.rds.amazonaws.com"
name = "appychip"
password = "12345678"
db_name = "appychip"


def main(event,context):
    result = []
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    data = (event['name'],event['host'], event['info'], now, event['person'],event['type'])
    add = ("INSERT INTO alertinfo "
              "(name, host, info, timein, person,type) "
              "VALUES (%s, %s, %s, %s, %s, %s)")
    with conn.cursor() as cur:
        cur.execute(add,data)
        cur.execute("select * from test")
        conn.commit()
        cur.close()
        for row in cur:
            result.append(list(row))
        print "Data from RDS..."
        print result
        print now
