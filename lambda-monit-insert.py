import logging
import boto3
import pymysql
import sys
import json
import datetime
now = datetime.datetime.now()

REGION = 'us-east-1'

rds_host  = "appychip.cqjqjnza85a5.us-east-1.rds.amazonaws.com"
name = "appychip"
password = "12345678"
db_name = "appychip"


def main(event,context):
    result = []
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    time = now.strftime("%Y-%m-%d %H:%M")
    rtime = now.strftime("%H")
    data = (event['name'], event['urgency'],event['host'], event['type'], time, rtime)
    add = ("INSERT INTO test "
              "(aname, urgency, host, type, ttime, htime) "
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





# event = {
#   "id": 777,
#   "name": "appychip"
# }
# context = ""
# main(event, context)
