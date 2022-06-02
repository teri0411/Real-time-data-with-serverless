import json
import boto3
import os

###
def sendLoc(event, context):
    kinesis_client = boto3.client('kinesis')
    body = json.loads(event['body'])
    
    if 'truckerId' not in body.keys():
        response = {"message":"wrong format"}
        return response

    response = kinesis_client.put_record(
        StreamName=os.environ['Kinesis_Data_Stream'],
        Data = bytes(json.dumps(body).encode('utf-8')),
        PartitionKey= body['truckerId']
    )
    return response