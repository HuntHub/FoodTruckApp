import json
import boto3
from botocore.exceptions import ClientError

def handler(event, context):
    print(f"Received event: {json.dumps(event)}")

    # Initialize a DynamoDB client
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('OrdersTable')  # Or whatever your table name is

    # Parse the order ID and new status from the event body
    body = json.loads(event['body'])
    payment_id = body['data']['object']['payment']['id']
    new_status = "Order Received"  # Assuming that the order status will be set to 'Order Received' when a payment is created

    # Generate a new order ID (for instance, using a UUID)
    import uuid
    order_id = str(uuid.uuid4())

    # Create a new order record
    try:
        table.put_item(
            Item={
                'order_id': order_id,
                'email': email,
                'order_status': new_status,
            }
        )

        response_body = f"Order {order_id} created with status {new_status}"
        status_code = 200
    except ClientError as e:
        print(e.response['Error']['Message'])
        response_body = "Failed to create order"
        status_code = 500

    return {
        'statusCode': status_code,
        'body': json.dumps(response_body)
    }