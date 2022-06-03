'use strict';
const AWS = require('aws-sdk');
// const credentials = new AWS.SharedIniFileCredentials({ profile: 'jang' });
const sns = new AWS.SNS({ region: 'ap-northeast-2' });

module.exports.hello = async (event) => {
  console.log(event)
  console.log("-------event-------")
  console.log(event['Records'][0]['body'])
  console.log("-------event['Records'][0]['body']-------")
  const body2 = event['Records'][0]['body']

  let body = JSON.parse(body2);
  console.log(body2)
  console.log("---위는 body----")
  let bodyvalue = JSON.stringify(body['Message']);

  let params = {
    TopicArn: process.env.SNS_TOPIC,
    Message: bodyvalue, /* required */
    MessageStructure: 'string'
  };

  console.log(bodyvalue)

  let response = sns.publish(params, function (err, data) {
    if (err) console.log(err, err.stack); 
    else console.log(data);
  });
  print(response)
};
