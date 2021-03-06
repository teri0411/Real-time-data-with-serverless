const AWS = require('aws-sdk')
//const elasticsearch = require("elasticsearch");

const { Client } = require("@opensearch-project/opensearch");
const elasticWatcher = require("elasticsearch-nodejs-watcher");

// const client = new elasticsearch.Client({
//  // hosts: ["http://localhost:9200"]
//   //프로토콜이 https이고 elasticsearch에 id, password가 있다면
//   hosts: ["https://yuni:Code0525!*@search-finalproject4-k6lhdxewrvpnueqayilulbszrq.ap-northeast-2.es.amazonaws.com/yuni_test/"]
// });

var host = "search-yuni-db-54dem7jsq2mifqsluvswlxmdle.ap-northeast-2.es.amazonaws.com";
var protocol = "https";
var auth = "yuni:Code0525!"; // For testing only. Don't store credentials in code.


var client = new Client({
  node: protocol + "://" + auth + "@" + host
  // ssl: {
  //   ca: fs.readFileSync(ca_certs_path),
  //   // You can turn off certificate verification (rejectUnauthorized: false) if you're using self-signed certificates with a hostname mismatch.
  //   // cert: fs.readFileSync(client_cert_path),
  //   // key: fs.readFileSync(client_key_path)
  // },
});


const connection = {
  host: protocol + "://" + auth + "@" + host,
};

//wss://9zp5kfvlug.execute-api.ap-northeast-2.amazonaws.com/production
const api = new AWS.ApiGatewayManagementApi({
  endpoint: '9zp5kfvlug.execute-api.ap-northeast-2.amazonaws.com/production'
})

const options = ['Yes', 'No', 'Maybe', 'Probably', 'Probably Not']

exports.handler = async (event) => {
    //let newevent = JSON.parse(event.Records[0].body)

    console.log("event : ", event);


    const route = event.requestContext.routeKey
    const connectionId = event.requestContext.connectionId

    switch (route) {
        case '$connect':
            console.log('Connection occurred')
            console.log(route);
            break
        case '$disconnect':
            console.log('Disconnection occurred')
            console.log(route);
            break
        case 'getLocation':
            console.log(route);
            
            console.log('Received message1:', event.body)
            //await replyToMessage(options[Math.floor(Math.random() * options.length)], connectionId)
            console.log('Received message2:', event.requestContext)
            client.cluster.health({},function(err,resp,status) {  
              console.log("-- Client Health --",resp);
            });
            console.log('Received message3:', event.requestContext)
            //elastic search get 요청

            var query = {
              query: {
                match: {
                  truckerId: {
                    query: "588866",
                  },
                },
              },
            };


            async function test() {
              try {
                let rs =  await client.search({
                  index: 'yuni',
                  type: 'yunitable',
                  body: query  
                });
                console.log("Search results:", rs);
                return rs;
              } catch (err) {
                console.error(err);
                return err;
              }
            }
            await test();



            const json = await test();
            console.log(JSON.stringify(json));
            console.log('Received message4:', event)
            await replyToMessage(JSON.stringify(json), connectionId)
            
            ////////////////////////////////////////////////////

              const watcher = {

                schedule: "*/3 * * * * *",
            
                query: {
            
                    index: 'yuni',
                    type: 'yunitable',
            
                    body: {
            
                        size: 10000,
            
                        query: {
            
                            bool: {
            
                                must: {
            
                                  match_all: {}
            
                                },
            
                                filter: {
            
                                  range: {"@timestamp_utc": {gte: "now-3s"}}
            
                                }
            
                            }
            
                        }
            
                    }
            
                },
            
                predicate: ({hits: {total}}) => total > 0,
            
                action: data => { 
                      console.log(data);
                      console.log('실행!!');
                      replyToMessage(JSON.stringify(json), connectionId)
            
                },
            
                errorHandler: err => console.log(JSON.stringify(err))
            
            };
            
            //elasticWatcher.schedule(connection, watcher);      
          
            ////////////////////////////////////////////////////




            //const test1 = JSON.stringify(json)
            //console.log("truckerID?", JSON.parse(test1).body.hits.hits[0]._source.truckerId)

          
            break;
          
        default:
          console.log('Received unknown route:', route)
    }

    return {
      statusCode: 200
    }

}

async function replyToMessage(response, connectionId) {
    const data = { message: response }
    const params = {
      ConnectionId: connectionId,
      Data: Buffer.from(JSON.stringify(data))
    }

    return api.postToConnection(params).promise()
}




