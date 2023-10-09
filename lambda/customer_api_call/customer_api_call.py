import json
import boto3
import requests
import os
import uuid
import base64

def generate_order_id():
    # Generates a URL-safe order ID using the os.urandom method.
    return base64.b64encode(os.urandom(9)).decode('utf-8').rstrip('==')

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
    headers = {"Authorization": f"Bearer {os.environ.get('SQUARE_API_TOKEN')}"}
    response = requests.get(square_api_url, headers=headers)

    if response.status_code == 200:
        customer_data = response.json()
        print(f"Received customer data: {customer_data}")

        # Extract first name and last initial
        first_name = customer_data['customer'].get('given_name', '')
        last_initial = customer_data['customer']['family_name'][0] if customer_data['customer'].get('family_name') else ''

        # Determine the order_id based on the provided conditions
        if first_name and last_initial:
            order_id = f"{first_name} {last_initial}"
        elif first_name:
            order_id = first_name
        else:
            order_id = generate_order_id()

        email = customer_data['customer']['email_address']  # Confirm this is the correct key path
        new_status = "Order Received"  # Assuming that the order status will be set to 'Order Received' when a payment is created

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