import json
import base64
import boto3
# from kinesis.producer import KinesisProducer

def hello(event, context):
    kinesis_client = boto3.client('kinesis')
    body = json.loads(event['body'])
    print(body)
    print(type(body)) # body => str

    response = kinesis_client.put_record(
        StreamName='project4',
        # Data = encode,
        Data = bytes(json.dumps(body).encode('utf-8')),
        # Data = base64.b64encode(json.dumps(body.encode('utf-8')), # str인 body를 json으로 변환 후 다시 str로 변환한 뒤 base64로 인코딩
        PartitionKey= body['truckerId']
    )
    
    return response