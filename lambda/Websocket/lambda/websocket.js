import Client from '../helper/client';
import Topic from '../helper/topic';
//
export async function handler(event) {
    try {
        console.log(`Received socket connectionId: ${event.requestContext && event.requestContext.connectionId}`);
        if (!(event.requestContext && event.requestContext.connectionId)) {
            throw new Error('Invalid event. Missing `connectionId` parameter.');
        }
        const connectionId = event.requestContext.connectionId;
        const route = event.requestContext.routeKey;
        console.log(`data from ${connectionId} ${event.body}`);

        const connection = new Client(connectionId);
        const response = { statusCode: 200, body: '' };

        if (route === '$connect') {
            console.log(`Route ${route} - Socket connectionId conected: ${event.requestContext && event.requestContext.connectionId}`);
            await new Client(connectionId).connect();
            return response;
        } else if (route === '$disconnect') {
            console.log(`Route ${route} - Socket connectionId disconnected: ${event.requestContext && event.requestContext.connectionId}`);
            await new Client(connectionId).unsubscribe();
            return response;
        } else {
            console.log(`Route ${route} - data from ${connectionId}`);
            if (!event.body) {
                return response;
            }

            let body = JSON.parse(event.body);

            const truckerId = body.truckerId;

            if (body.type === 'truckerId') {
                connection.subscribe({ truckerId });
                console.log(`Client subscribing for truckerId: ${truckerId}`);
            }

            if (body.type === 'data') {
                await new Topic(truckerId).publishMessage({ data: body });
                console.error(`Published data to subscribers`);
                return response;
            }

            if (body.type === 'stop') {
                return response;
            }

            return response;
        }
    } catch (err) {
        console.error(err.data);
    }
    ///////
//????????????????
    return null;
}
