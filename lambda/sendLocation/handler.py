import json
import boto3

def hello(event, context):
    kinesis_client = boto3.client('kinesis')
    body = json.loads(event['body'])
    # print(body)

    response = kinesis_client.put_record(
        StreamName='project4',
        Data = bytes(json.dumps(body).encode('utf-8')),
        PartitionKey= body['truckerId']
    )
    
    return response