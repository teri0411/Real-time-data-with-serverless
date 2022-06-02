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
    credentials = boto3.Session().get_credentials('default')
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
        response = search.index(index="status", doc_type="_doc", id=id, body=document)
        # response = requests.put()
        print(response)
        return response
    elif status == 1:
        document = {"id": id, "status": "end"}
        response = search.index(index="status", doc_type="_doc", id=id, body=document)
        print(response)
        return response
    print(3)

def start(event, context):
    message = {"message": "start delivery"}
    id = event['body']
    id = json.loads(id)['id']
    publishSNS(str(message)) #{"statusCode": 200, "body": message}
    response = changeStatus(0, id)
    return response

def end(event, context):
    message = {"message": "end delivery"}
    id = event['body']
    id = json.loads(id)['id']
    # response = publishSNS(str(message))
    response = changeStatus(1, id)
    return response