const WebSocket = require('ws');

const sockedEndpoint = 'wss://dsvx5qnze1.execute-api.ap-northeast-2.amazonaws.com/dev';
const ws1 = new WebSocket(sockedEndpoint, {
  perMessageDeflate: false
});

const ws2 = new WebSocket(sockedEndpoint, {
  perMessageDeflate: false
});




ws1.on('open', () => {
    console.log('Ws1 connected');
    let count = 0;
    setInterval(() => {

      const data = {
        type: 'data',
        message: `count is ${count}`,
        truckerId: '588866'
      }
      const message  = JSON.stringify(data);
      ws1.send(message, (err) => {
        if(err) {
          console.log(`Error occurred while send data ${err.message}`)
        }
        console.log(`소비자의 요청에 곧 응답합니다 ${message}`);
      })
      count++;
    }, 5000)
})



ws2.on('open', () => {
  console.log('Ws2 connected');
  const data = {
    type: 'truckerId',
    truckerId: '588866'
  }
  ws2.send(JSON.stringify(data), (err) => {
    if(err) {
      console.log(`Error occurred while send data ${err.message}`)
    }
  })
})


ws2.on('message', (message) => {
  console.log(`소비자님 이쯤에 있어요! ${message}`);
})


