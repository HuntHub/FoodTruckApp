import boto3
import os
import logging

# Initialize logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# DynamoDB setup
dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get("CONNECTIONS_TABLE", "WebSocketConnections")  # Fetch from environment variable or use default
table = dynamodb.Table(table_name)

def handler(event, context):
    connection_id = event["requestContext"]["connectionId"]
    try:
        table.delete_item(Key={"connectionId": connection_id})
        logger.info(f"Connection ID {connection_id} removed.")
        return {
            'statusCode': 200,
            'body': 'Disconnected.'
        }
    except Exception as e:
        logger.error(f"Error removing connection ID {connection_id}. Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': 'Failed to disconnect.'
        }