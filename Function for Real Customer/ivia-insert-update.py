import logging
import boto3
import pymysql
import sys
import json
import datetime
now = datetime.datetime.now()

REGION = 'us-east-1'

rds_host  = "appychip.cae99tn0ffoc.us-east-1.rds.amazonaws.com"
name = "appychip"
password = "12345678"
db_name = "appychip"

def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()

def main(event,context):
    result = []
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    x = event['name'].split(": ")[0]
    z = event['name'].split(": ")[1]
    lname = z.split(" -")[0]
    lname = "Ping error on " + lname
    time = (event['ttime'][:19])
    type = "Trigger"
    datetime_newtime = datetime.datetime.strptime(time,'%Y-%m-%d %H:%M:%S')
    datetime_newtime = datetime_newtime + datetime.timedelta(hours=7)
    print lname
    print datetime_newtime
    if x=="Ping CRITICAL":
        with conn.cursor() as cur:
            cur.execute("insert into alerttrigger(name, host, urgency, type, ttime) values (%s, %s, %s, %s, %s)",(lname,event['host'],event['urgency'],type, datetime_newtime))
            conn.commit()
            cur.close()
            return "Proccess A"
    if x=="Ping OK":
        with conn.cursor() as cur:
            cur.execute("update alerttrigger set type='Resolve',rtime =%s where name =%s and host = %s and type = 'Trigger'",(datetime_newtime,lname,event['host']))
            conn.commit()
            cur.close()
            return "Proccess B"
    
    

#    dately = json.dumps(event['ttime'], default = myconverter)
#    data = (event['name'], event['urgency'],event['host'], event['type'], event['ttime'], event['rtime'])
#    add = ("INSERT INTO alerttrigger "
#              "(name, urgency, host, type, ttime, htime) "
#              "VALUES (%s, %s, %s, %s, %s, %s)")
#    with conn.cursor() as cur:
#        cur.execute(add,data)
#        cur.execute("select * from alerttrigger")
#        conn.commit()
#        cur.close()
#        for row in cur:
#            result.append(list(row))
