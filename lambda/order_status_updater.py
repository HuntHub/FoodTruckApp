import json
import boto3
from botocore.exceptions import ClientError


def handler(event, context):
    print(f"Received event: {json.dumps(event)}")

    # Initialize a DynamoDB client
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('OrdersTable')  # Or whatever your table name is

    # Initialize a SES client
    ses = boto3.client('ses', region_name='us-east-1')  # replace 'us-east-1' with your region

    # Parse the order ID and new status from the event body
    body = json.loads(event['body'])
    order_id = body['order_id']
    new_status = body['new_status']

    # Get the order from DynamoDB
    try:
        response = table.get_item(Key={'order_id': order_id})
        if 'Item' not in response:
            # Order does not exist, handle it.
            print(f"Order {order_id} does not exist")
            return {
                'statusCode': 404,
                'body': json.dumps(f"Order {order_id} not found")
            }
        else:
            order = response['Item']
            email_recipient = order['email']  # Replace 'email' with the actual name of your email field
    except ClientError as e:
        print(e.response['Error']['Message'])
        return {
            'statusCode': 500,
            'body': json.dumps("Failed to get order")
        }

    # If we have reached this point, we have the order and can update it
    try:
        table.update_item(
            Key={'order_id': order_id},
            UpdateExpression='SET #os = :s',
            ExpressionAttributeNames={'#os': 'order_status'},
            ExpressionAttributeValues={':s': new_status}
        )

        response_body = f"Order {order_id} updated to {new_status}"
        status_code = 200

        # If order status updated to 'Ready', send an email
        if new_status == 'Ready':
            email_subject = "Order Status Update"
            email_body = f"Your order {order_id} is now Ready."
            email_source = "cloudbridgega@gmail.com"  # replace with your verified SES email

            try:
                ses.send_email(
                    Destination={
                        'ToAddresses': [email_recipient]
                    },
                    Message={
                        'Body': {
                            'Text': {
                                'Data': email_body
                            },
                        },
                        'Subject': {
                            'Data': email_subject
                        },
                    },
                    Source=email_source
                )
            except ClientError as e:
                print(f"Failed to send email: {e.response['Error']['Message']}")

    except ClientError as e:
        print(e.response['Error']['Message'])
        response_body = "Failed to update order"
        status_code = 500

    return {
        'statusCode': status_code,
        'body': json.dumps(response_body)
    }