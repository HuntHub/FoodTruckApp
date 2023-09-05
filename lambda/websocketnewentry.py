import boto3
import json
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('WebSocketConnections')
websocket_url = os.environ['websocket_url']

def handler(event, context):
    client = boto3.client('apigatewaymanagementapi', endpoint_url=websocket_url)
    
    for record in event['Records']:
        if record['eventName'] == 'INSERT':
            order_id = record['dynamodb']['Keys']['order_id']['S']
            
            # Simply notify connected clients of the updated order
            send_websocket_notification(client, order_id)

    return {
        'statusCode': 200,
        'body': 'Processed.'
    }

def send_websocket_notification(client, order_id):
    # Get all connection IDs with pagination
    connection_ids = []
    scan_kwargs = {}
    done = False
    while not done:
        response = table.scan(**scan_kwargs)
        connection_ids.extend([item['connectionId'] for item in response.get('Items', [])])
        start_key = response.get('LastEvaluatedKey', None)
        done = start_key is None
        scan_kwargs['ExclusiveStartKey'] = start_key

    # Broadcast message to all connected clients about the updated order
    for connection_id in connection_ids:
        try:
            client.post_to_connection(
                ConnectionId=connection_id,
                Data=json.dumps({"message": "Order updated", "order_id": order_id})
            )
        except client.exceptions.GoneException:
            # Client is no longer connected. Remove from DynamoDB
            table.delete_item(Key={"connectionId": connection_id})
