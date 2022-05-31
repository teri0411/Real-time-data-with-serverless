const WebSocket = require('ws');

const sockedEndpoint = 'wss://6m15wzeari.execute-api.ap-northeast-2.amazonaws.com/dev';
const ws1 = new WebSocket(sockedEndpoint, {
  perMessageDeflate: false
});

const ws2 = new WebSocket(sockedEndpoint, {
  perMessageDeflate: false
});

const ws3 = new WebSocket(sockedEndpoint, {
  perMessageDeflate: false
});

const ws4 = new WebSocket(sockedEndpoint, {
  perMessageDeflate: false
});

const ws5 = new WebSocket(sockedEndpoint, {
  perMessageDeflate: false
});

const ws6 = new WebSocket(sockedEndpoint, {
  perMessageDeflate: false
});


ws1.on('open', () => {
    console.log('WS1 connected');
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
        console.log(`이걸로 요청중이다 ${message}`);
      })
      count++;
    }, 5000)
})

ws2.on('open', () => {
  console.log('WS2 connected');
  let count = 0;
  setInterval(() => {

    const data = {
      type: 'data',
      message: `count is ${count}`,
      truckerId: '588866'
    }
    const message  = JSON.stringify(data);
    ws2.send(message, (err) => {
      if(err) {
        console.log(`Error occurred while send data ${err.message}`)
      }
      console.log(`이걸로 요청중이다 ${message}`);
    })
    count++;
  }, 5000)
})

ws3.on('open', () => {
  console.log('WS3 connected');
  let count = 0;
  setInterval(() => {

    const data = {
      type: 'data',
      message: `count is ${count}`,
      truckerId: '588866'
    }
    const message  = JSON.stringify(data);
    ws3.send(message, (err) => {
      if(err) {
        console.log(`Error occurred while send data ${err.message}`)
      }
      console.log(`이걸로 요청중이다 ${message}`);
    })
    count++;
  }, 5000)
})

ws4.on('open', () => {
  console.log('WS4 connected');
  let count = 0;
  setInterval(() => {

    const data = {
      type: 'data',
      message: `count is ${count}`,
      truckerId: '588866'
    }
    const message  = JSON.stringify(data);
    ws4.send(message, (err) => {
      if(err) {
        console.log(`Error occurred while send data ${err.message}`)
      }
      console.log(`이걸로 요청중이다 ${message}`);
    })
    count++;
  }, 5000)
})

ws5.on('open', () => {
  console.log('WS5 connected');
  let count = 0;
  setInterval(() => {

    const data = {
      type: 'data',
      message: `count is ${count}`,
      truckerId: '588866'
    }
    const message  = JSON.stringify(data);
    ws5.send(message, (err) => {
      if(err) {
        console.log(`Error occurred while send data ${err.message}`)
      }
      console.log(`이걸로 요청중이다 ${message}`);
    })
    count++;
  }, 5000)
})

ws6.on('open', () => {
  console.log('WS6 connected');
  const data = {
    type: 'truckerId',
    truckerId: '588866'
  }
  ws6.send(JSON.stringify(data), (err) => {
    if(err) {
      console.log(`Error occurred while send data ${err.message}`)
    }
  })
})


ws6.on('message', (message) => {
  console.log(`데이터받았다~ ${message}`);
})


