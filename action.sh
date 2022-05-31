# 실행명령어 : source action.sh
#!/bin/bash
# unset ENDPOINT_URL
# cd lambda && cd Websocket
# sls deploy
# export ENDPOINT_URL=$(aws lambda get-function-url-config --function-name websocket-app-dev-publish | jq .FunctionUrl -r)
# echo $ENDPOINT_URL
# sls deploy

cd /mnt/c/users/s/devops-01-final-TeamC-Scenario-02/tf

terraform apply -lock=false -var ENDPOINT_URL=$ENDPOINT_URL
cd ..
