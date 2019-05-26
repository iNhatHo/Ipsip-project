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
    host = ""
    lname = ""
    lname = event.get('name',"not")
    host = event.get('host',"not")
    if len(lname) == 0:
        lname = "not"
    else:
        lname = event.get('name',"not")
    if len(host) == 0:
        host = "not"
    else:
        host = event.get('host',"not")
    print lname
    print host
    with conn.cursor() as cur:
        if lname != "not" and host == "not":
            cur.execute("""select id,name,host,info,timein,person,type from alertinfo where name =%s order by timein desc""", (lname))
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'id': row[0], 'name': row[1], 'host': row[2],'info': row[3], 'timein': row[4],'person': row[5],'type': row[6]})
            print "process A"
        if lname != "not" and host != "not":
            cur.execute("""select id,name,host,info,timein,person,type from alertinfo where name =%s and host =%s order by timein desc""", (lname,host))
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'id': row[0], 'name': row[1], 'host': row[2],'info': row[3], 'timein': row[4],'person': row[5],'type': row[6]})
            print "process B"
        if lname == "not" and host != "not":
            cur.execute("""select id,name,host,info,timein,person,type from alertinfo where host =%s order by timein desc """, (host))
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'id': row[0], 'name': row[1], 'host': row[2],'info': row[3], 'timein': row[4],'person': row[5],'type': row[6]})
            print "process C"
        if lname == "not" and host == "not":
            return "Missing name & host"
    o = json.dumps(result, default = myconverter)
    new = json.loads(o)
    return (new)
