import json
import boto3
from opensearchpy import OpenSearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth
import requests
import os

def publishSNS(message):
    sns = boto3.client('sns')
    response = sns.publish(
        TopicArn=os.environ['SNS_TOPIC'],
        Message=message,
        MessageStructure='string'
    )
    return response
    
def changeStatus(status, id):
    URL = os.environ['OPENSEARCH_ENDPOINT'] # + ':9200'
    region = "ap-northeast-2"
    service = 'es'
    credentials = boto3.Session().get_credentials()
    print(0)
    awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)
    print(1)
    search = OpenSearch(
        hosts = [{'host': URL, 'port': 443}],
        http_auth = awsauth,
        use_ssl = True,
        verify_certs = True,
        connection_class = RequestsHttpConnection
    )
    print(2)
    if status == 0:
        document = {"id": id, "status": "start"}
        response = search.index(index="status", id=id, body=document)
        print(response)
        return response
    elif status == 1:
        document = {"id": id, "status": "end"}
        response = search.index(index="status", id=id, body=document)
        print(response)
        return response

def start(event, context):
    message = {"message": "start delivery"}
    id = event['body']
    id = json.loads(id)['id']
    print(id)
    publishSNS(str(message)) #{"statusCode": 200, "body": message}
    print(event)
    response = changeStatus(0, id)
    return response

def end(event, context):
    message = {"message": "end delivery"}
    id = event['body']
    id = json.loads(id)['id']
    response = publishSNS(str(message))
    response = changeStatus(1, id)
    return response