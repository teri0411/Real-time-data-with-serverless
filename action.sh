# 실행명령어 : source action.sh
#!/bin/bash


cd lambda && cd Websocket
export AWS_DEFAULT_REGION=ap-northeast-2
sls deploy #아무것도 없을때 이 명령어 사용 (처음배포해놔야 url잡을 수 있다.)

export ENDPOINT_URL=$(aws lambda get-function-url-config --function-name websocket-app-dev-publish | jq .FunctionUrl -r)
echo $ENDPOINT_URL
export WEBSOCKET=$(aws apigatewayv2 get-apis | jq .Items -r | jq -c '.[] | select(.Name | contains("websocket"))'.ApiEndpoint -r | sed -e "s/\$/\/dev/g")
echo $WEBSOCKET
export WEBSOCKET_URL=$(aws apigatewayv2 get-apis | jq .Items -r | jq -c '.[] | select(.Name | contains("websocket"))'.ApiEndpoint -r | sed 's/\wss/https/g' | sed -e "s/\$/\/dev/g")
echo $WEBSOCKET_URL
sls deploy

cd .. && cd ..
cd tf
terraform init
#aws iam create-service-linked-role --aws-service-name opensearchservice.amazonaws.com (처음배포이면 풀것)
terraform apply -var ENDPOINT_URL=$ENDPOINT_URL -lock=false

cd ..
cd lambda && cd changeDeliveryStatus
sls deploy

cd .. && cd ..
cd lambda && cd getLocation
sls deploy

cd .. && cd ..
cd lambda && cd sendLocation
sls deploy

cd .. && cd ..
cd lambda && cd sendNotification
sls deploy
cd ..
