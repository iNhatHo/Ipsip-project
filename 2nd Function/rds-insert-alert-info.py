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
    
    lname = event.get('name',"not")
    host = event.get('host',"not")
    info = event.get('info',"not")
    person = event.get('person',"not")
    typee = event.get('type',"not")
    if len(lname) == 0:
        lname = "not"
    else:
        lname = event.get('name',"not")
    if len(host) == 0:
        host = "not"
    else:
        host = event.get('host',"not")
    if len(info) == 0:
        info = "not"
    else:
        info = event.get('info',"not")
    if len(person) == 0:
        person = "not"
    else:
        person = event.get('person',"not")
    if len(typee) == 0:
        typee = "not"
    else:
        typee = event.get('type',"not")
    print lname
    print now
    data = (lname,host,info,person,typee)
    add = ("INSERT INTO alertinfo "
              "(name, host, info, timein, person,type) "
              "VALUES (%s, %s, %s, %s, %s, %s)")
    if lname == "not" or host == "not" or info == "not" or person =="not":
        return "Missing information"
    if lname != "not" and host != "not" and info != "not" or person != "not":
        with conn.cursor() as cur:
            cur.execute("insert into alertinfo(name,host,info,timein,person,type) values(%s,%s,%s,%s,%s,%s)",(lname,host,info,(now),person,typee))
            conn.commit()
            cur.close()
            return lname
    else:
        return "missing information"
