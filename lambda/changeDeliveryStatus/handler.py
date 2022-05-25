import json
import boto3

client = boto3.client('es') # boto3.client('opensearch')
def publishSNS(message):
    client = boto3.client('sns')
    response = client.publish(
        TopicArn='arn:aws:sns:ap-northeast-2:889058321615:DeliveryStatus',
        Message=message,
        MessageStructure='string'
        )
    return response
    

def start(event, context):
    message = {"message": "start delivery"}

    response = publishSNS(str(message)) #{"statusCode": 200, "body": message}

    return response

def end(event, context):
    message = {"message": "end delivery"}
    response = publishSNS(str(message))
    # response = {"statusCode": 200, "body": message}

    return response
