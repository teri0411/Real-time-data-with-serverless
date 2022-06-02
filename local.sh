# 실행명령어 : source local.sh
#!/bin/bash


cd lambda && cd Websocket
#sls deploy #아무것도 없을때 이 명령어 사용 (처음배포해놔야 url잡을 수 있다.)
export AWS_DEFAULT_REGION=ap-northeast-2
export ENDPOINT_URL=$(aws lambda get-function-url-config --function-name websocket-app-dev-publish | jq .FunctionUrl -r)
echo $ENDPOINT_URL
export WEBSOCKET=$(aws apigatewayv2 get-apis | jq .Items -r | jq -c '.[] | select(.Name | contains("websocket"))'.ApiEndpoint -r | sed -e "s/\$/\/dev/g")
echo $WEBSOCKET
export WEBSOCKET_URL=$(aws apigatewayv2 get-apis | jq .Items -r | jq -c '.[] | select(.Name | contains("websocket"))'.ApiEndpoint -r | sed 's/\wss/https/g' | sed -e "s/\$/\/dev/g")
echo $WEBSOCKET_URL
sls deploy
cd .. && cd ..
cd tf

terraform apply -var ENDPOINT_URL=$ENDPOINT_URL
cd ..
