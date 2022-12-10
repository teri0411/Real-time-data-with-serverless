const AWS = require('aws-sdk')


const { Client } = require("@opensearch-project/opensearch");
const elasticWatcher = require("elasticsearch-nodejs-watcher");



var host = "search-yuni-db-54dem7jsq2mifqsluvswlxmdle.ap-northeast-2.es.amazonaws.com";
var protocol = "https";
var auth = "yuni:Code0525!"; // For testing only. Don't store credentials in code.


var client = new Client({
  node: protocol + "://" + auth + "@" + host
});


const connection = {
  host: protocol + "://" + auth + "@" + host,
};


const api = new AWS.ApiGatewayManagementApi({
  endpoint: '9zp5kfvlug.execute-api.ap-northeast-2.amazonaws.com/production'
})

const options = ['Yes', 'No', 'Maybe', 'Probably', 'Probably Not']

exports.handler = async (event) => {
    

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
            
            console.log('Received message2:', event.requestContext)
            client.cluster.health({},function(err,resp,status) {  
              console.log("-- Client Health --",resp);
            });
            console.log('Received message3:', event.requestContext)
            

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




