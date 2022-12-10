import base64
import requests
import json
import boto3
import os
from boto3.dynamodb.conditions import Key
import botocore

def lambda_handler(event, context):


  try:
######################################################
    test = event["body"]
    json_data = json.loads(test)
    value = json_data["records"][0]
    data = value["data"]
    base64_bytes = data.encode('ascii')
    decodedBytes = base64.b64decode(base64_bytes)
    msg = decodedBytes.decode('ascii')
 
    msg_data = json.loads(msg)
    truckerId = msg_data["truckerId"]
      

    client = boto3.client(
      'dynamodb',
      aws_access_key_id= os.environ['aws_access_key_id'] ,
      aws_secret_access_key= os.environ['aws_secret_key_id'],
      )
    dynamodb = boto3.resource(
      'dynamodb',
      aws_access_key_id= os.environ['aws_access_key_id'],
      aws_secret_access_key= os.environ['aws_secret_key_id'],
      )

    table = dynamodb.Table('connection')
    response = table.scan()
    data2 = response['Items']
    while 'truckerId' in response:
      response = table.scan(ExclusiveStartKey=response['truckerId'])
      data2.extend(response['Items'])

      
    clientApi = boto3.client('apigatewaymanagementapi', endpoint_url= os.environ['WEBSOCKET_URL'])
    connectionId = response['Items'][0]["connectionId"]

    result = table.query(
          KeyConditionExpression=Key('truckerId').eq('588866')
      )
 

    if result["Count"]>0:
      clientApi.post_to_connection(Data=msg, ConnectionId=connectionId)
      print(result["Count"])
      print("진입!!!")
    else:
      print("아이템없어서 못줌")


  except:
    print("try 못함")

  response = requests.get(os.environ['WEBSOCKET_URL'])
  print(response)

  requestId = json_data["requestId"]
  return {
      'recordId': requestId,
      'result': 'Ok',
      'data': msg_data
        }


