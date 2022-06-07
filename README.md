# 화물 드라이버 위치 추적 시스템
### 시나리오
> 화물운송 1등 기업 센디는 화물용달 예약 서비스를 제공합니다. 예약을 성공적으로 진행한 후, 화물 용달이 실제로 운송중일 경우, 고객은 이러한 운송 정보를 실시간으로 파악할 수 있어야 합니다.
### 요구사항
* 소비자는 예약 후, 매칭이 이루어진 드라이버의 실시간 정보를 받아올 수 있어야 합니다.
* 드라이버 전용 앱은 별도로 구성하며, 위치 데이터 스트림이 JSON 형식으로 실시간으로 전송되어야 합니다.
* 스트림 데이터 처리는 Kinesis Data Stream, Kinesis Data Firehose 사용을 고려해볼 수 있습니다.
* 드라이버 위치 정보에 대한 로그는 Elasticsearch를 이용합니다.
* 서비스 간의 연결은 서버리스 형태로 구성해야 합니다.
### 추가 요구사항(요구사항 미팅 후 추가)
* 드라이버의 위치 정보는 전체 경로를 불러올 필요는 없고 현재 위치만 불러오면 된다.
* 예상 경로는 제공하지 않는다.
* 예약 정보 리스트 조회화면에서는 실시간 위치를 반영하지 않는다.

## 아키텍처
![image](https://user-images.githubusercontent.com/75375944/172033154-d9e46dea-5372-49b6-8611-ecb0a76f6630.png)

Create a new directory, navigate to that directory in a terminal and clone the GitHub repository:

$git clone https://github.com/teri0411/Real-time-data-with-serverless.git


## Deployment Instructions
During the prompts:

- Enter the AWS configure list
- Enter the desired AWS Region
- Create your .env file
- Input the AWS key into env file.

```
$source action.sh
```
From the command line, Use Shell Script

## Testing
1. Change directory to the pattern directory:
```
cd Real-time-data-with-serverless/lambda/Websocket/
``
2. Send your data using k6 :
```
$k6 run datainsert.js
``
3 Open your Websocket API :
```
$node ws-client
``
4. You will see your data being received in the ws-client.

## Clean up
1. Change directory to the pattern directory:
```
$serverless remove
```
2. Change directory to the pattern directory:
```
$terraform destroy
```
