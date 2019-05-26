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
    result1 = []
    result2 = []
    result4 = []
    result5 = []
    timebegin =event.get('timebegin','1000-01-01')
    timeend =event.get('timeend','3000-01-01')
    with conn.cursor() as cur:
        cur.execute("select COALESCE(host,'Total'), cnt from (select host, count(*) as cnt from alerttrigger where ttime > %s and ttime < %s group by host with rollup) mygroup_with_rollup order by host is null, cnt desc, host",(timebegin,timeend))
        conn.commit()
        cur.close()
        for row in cur:
            result.append({'name': row[0], 'amount': row[1]})
    with conn.cursor() as cur1:
        cur1.execute("select COALESCE(name,'Total'), cnt from (select name, count(*) as cnt from alerttrigger where ttime > %s and ttime < %s group by name with rollup) mygroup_with_rollup order by name is null, cnt desc, name",(timebegin,timeend))
        conn.commit()
        cur1.close()
        for row in cur1:
            result1.append({'name': row[0],'amount': row[1]})
    with conn.cursor() as cur2:
        cur2.execute("select distinct hour(ttime), count(*) as num from alerttrigger where ttime > %s and ttime < %s group by hour(ttime) order by count(*) desc LIMIT 5",(timebegin,timeend))
        conn.commit()
        cur2.close()
        for row in cur2:
            result2.append({'Time': row[0], 'amount': row[1]})
    with conn.cursor() as cur4:
        cur4.execute("select distinct name, host, count(*) from alertinfo where timein > %s and timein < %s group by name order by count(*) desc limit 3",(timebegin,timeend))
        conn.commit()
        cur4.close()
        for row in cur4:
            result4.append({'name': row[0],'host':row[1], 'amount': row[2]})
    with conn.cursor() as cur5:
        cur5.execute("select distinct name, host, ttime, rtime from alerttrigger where ttime > %s and ttime < %s and rtime is not NULL group by name,host order by timediff(ttime,rtime) LIMIT 3",(timebegin,timeend))
        conn.commit()
        cur5.close()
        for row in cur5:
            result5.append({'name': row[0], 'host': row[1],'ttime': row[2],'rtime':row[3]})
    o = json.dumps(result, default = myconverter)
    p = json.dumps(result1, default = myconverter)
    i = json.dumps(result2, default = myconverter)
    u = json.dumps(result4, default = myconverter)
    t = json.dumps(result5, default = myconverter)
    newo = json.loads(o)
    newp = json.loads(p)
    newi = json.loads(i)
    newu = json.loads(u)
    newt = json.loads(t)
    final = {"message": newo, "message1": newp, "message2": newi,"message3": newu,"message4": newt}
    finals = json.dumps(final)
    finalss = json.loads(finals)
    return (finalss)
