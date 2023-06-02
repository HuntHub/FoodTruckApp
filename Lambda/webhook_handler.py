import json
import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('OrdersTable')

def handler(event, context):
    # Check if body is present
    if 'body' not in event:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "message": "Bad Request, body is required."
            }),
        }

    # Parse the body of the request
    body = json.loads(event['body'])

    # Check if email and order details are present in the request
    if 'email' not in body or 'order_details' not in body:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "message": "Bad Request, email and order_details are required."
            }),
        }

    email = body['email']
    order_details = body['order_details']

    # Generate unique order ID
    order_id = str(uuid.uuid4())

    # Put the order into DynamoDB
    table.put_item(
        Item={
            'order_id': order_id,
            'email': email,
            'order_status': 'Received',
            'order_details': order_details
        }
    )

    # Return a successful response
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Order received successfully",
            "order_id": order_id
        }),
    }
