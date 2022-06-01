import dynamoDBClient from '../utils/dynamodb';
import Client from './client';


class Topic {
  truckerId;
  constructor(truckerId) {
    this.truckerId = truckerId;
  }

  async getSubscribers() {
    const { Items: truckerId } = await dynamoDBClient
      .query({
        ExpressionAttributeValues: {
          ':truckerId': this.truckerId,
        },
        KeyConditionExpression: 'truckerId = :truckerId',
        ProjectionExpression: 'connectionId, subscriptionId',
        TableName: process.env.TOPICS_TABLE,
      })
      .promise();
    return truckerId;
  }

  async publishMessage(data) {
    const subscribers = await this.getSubscribers();
    console.debug(`Publishing ${JSON.stringify(data)} to subscribers ${JSON.stringify(subscribers)}`);
    if (!subscribers) {
      console.error(`No subscribers to publish data`);
      throw Error(`no subscribers to publish ${console.log(data)}`);
    }
    const promises = subscribers.map(async ({ connectionId, subscriptionId }) => {
      const TopicSubscriber = new Client(connectionId);
      try {
        const res = await TopicSubscriber.sendMessage({
          id: truckerId,
          payload: { data },
          type: 'data',
        });
        return res;
      } catch (err) {
        console.error(`Error${connectionId} ${console.log(err)}`);
        if (err.statusCode === 410) {
          return TopicSubscriber.unsubscribe();
        }
      }
    });
    return Promise.all(promises);
  }
}

export default Topic;

//???
