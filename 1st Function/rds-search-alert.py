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
    lname = event.get('name',"not")
    host = event.get('host',"not")
    urgency = event.get('host',"not")
    type = event.get('type',"not")
    with conn.cursor() as cur:
        if lname != "not" and host == "not" and type == "not" and urgency == "not":
            cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where name =%s""", event['name'])
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
        if lname != "not" and host != "not" and type == "not" and urgency == "not:
            cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where name =%s and host =%s""", lname,host)
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
		if lname != "not" and host == "not" and type != "not" and urgency == "not:
            cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where name =%s and type =%s""", lname,type)
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
		if lname != "not" and host == "not" and type == "not" and urgency != "not:
            cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where name =%s and urgency =%s""", lname,urgency)
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
		if lname == "not" and host != "not" and type == "not" and urgency == "not:
            cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where host =%s""", host)
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
		if lname == "not" and host != "not" and type != "not" and urgency == "not:
            cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where host =%s and type =%s""", host,type)
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
		if lname == "not" and host != "not" and type == "not" and urgency != "not:
            cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where host = %s and urgency = %s""", host,urgency)
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
		if lname == "not" and host == "not" and type != "not" and urgency != "not:
            cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where type =%s and urgency =%s""", host,urgency)
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
		if lname == "not" and host == "not" and type != "not" and urgency == "not:
            cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where type =%s""", type)
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
		if lname == "not" and host == "not" and type == "not" and urgency != "not:
            cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where urgency =%s""", urgency)
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
		if lname != "not" and host != "not" and type != "not" and urgency = "not:
            cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where name =%s and host =%s and type =%s""",lname,host,type)
            conn.commit()
            cur.close()
            for row in cur:
                result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
    o = json.dumps(result, default = myconverter)
    new = json.loads(o)
    return (new)
#        cur.execute("""select ttime,id,name,type,urgency,host from alerttrigger where name =%s""", event['name'])
#        conn.commit()
#        cur.close()
#        for row in cur:
#            result.append({'ttime': row[0], 'id': row[1], 'name': row[2],'type': row[3], 'urgency': row[4],'host': row[5]})
#    o = json.dumps(result, default = myconverter)
#    new = json.loads(o)
#    return (new)
