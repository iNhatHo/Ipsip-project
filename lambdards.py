# A lambda function to interact with AWS RDS MySQL
import logging
import boto3
import pymysql
import sys
import json

REGION = 'us-east-1'

rds_host  = "appychip.cqjqjnza85a5.us-east-1.rds.amazonaws.com"
name = "appychip"
password = "12345678"
db_name = "appychip"

logger = logging.getLogger()
logger.setLevel(logging.INFO)

try:
    mydb = pymysql.connect(host=rds_host, user=name, password=password, db=db_name, connect_timeout=5, cursorclass=pymysql.cursors.DictCursor)
except:
    logger.error("ERROR: Unexpected error: Could not connect to MySql instance.")
    sys.exit()

logger.info("SUCCESS: Connection to RDS mysql instance succeeded")

def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()

def main(event,context):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    mycursor = mydb.cursor()
    mycursor.execute("SELECT * FROM test")
    myresult = mycursor.fetchall()
    final=json.dumps(myresult, default = myconverter)
    newString = final.replace('\','')
    return (newString)





# event = {
#   "id": 777,
#   "name": "appychip"
# }
# context = ""
# main(event, context)
