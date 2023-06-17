import json
import boto3
import requests
import os
import uuid

def handler(event, context):
    print(f"Received event: {json.dumps(event)}")
    
    # Initialize a DynamoDB client
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('OrdersTable')  # Or whatever your table name is

    # Parse the message body
    body = json.loads(event['Records'][0]['body'])
    customer_id = body.get('customer_id')

    if not customer_id:
        print("No customer_id in message body")
        return {'statusCode': 400, 'body': "No customer_id in message body"}

    # Make a GET request to the Customers API
    square_api_url = f"https://connect.squareupsandbox.com/v2/customers/{customer_id}"
    headers = {"Authorization": f"Bearer EAAAEP55lWQwSc-rSQS41rzwSKKCZIyJ2I1GitMw49ZA0jvNc6wbsX5eHq8luQi0"}  # Pull Square API token from environment variables
    response = requests.get(square_api_url, headers=headers)

    if response.status_code == 200:
        customer_data = response.json()
        print(f"Received customer data: {customer_data}")
        email = customer_data['customer']['email_address']  # Confirm this is the correct key path
        new_status = "Order Received"  # Assuming that the order status will be set to 'Order Received' when a payment is created

        # Generate a new order ID (for instance, using a UUID)
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
        except Exception as e:
            print(str(e))
            response_body = "Failed to create order"
            status_code = 500
    else:
        print(f"Failed to retrieve customer data with response code: {response.status_code}")
        response_body = "Failed to retrieve customer data"
        status_code = 500

    print({
        'statusCode': status_code,
        'body': response_body
    })