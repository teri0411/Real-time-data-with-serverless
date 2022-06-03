'use strict';
const AWS = require('aws-sdk');
// const credentials = new AWS.SharedIniFileCredentials({ profile: 'jang' });
const sns = new AWS.SNS({ region: 'ap-northeast-2' });

module.exports.hello = async (event) => {
  console.log(event)
  console.log("-------event-------")
  console.log(event['Records'][0]['body'])
  console.log("-------event['Records'][0]['body']-------")
  const body = event['Records'][0]['body']
  console.log(body)
  console.log("---위는 body----")
  const bodyvalue = event['Records'][0]['body']['Message']
  console.log(bodyvalue)

  let params = {
    Message: bodyvalue, /* required */
    TopicArn: process.env.SNS_TOPIC
  };

  let response = sns.publish(params, function (err, data) {
    if (err) console.log(err, err.stack); 
    else console.log(data);
  });
  return response;
  //hello anyone?
  //hi
  //hi?
  //hello???
  //??  
  //? ?
  //???
  // return { message: 'Go Serverless v1.0! Your function executed successfully!', event };
};
