import json
import boto3
from botocore.exceptions import ClientError

def handler(event, context):
    print(f"Received event: {json.dumps(event)}")
    response_body = 'Success'  # default value
    status_code = 200  # default value

    # Initialize a DynamoDB client
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('OrdersTable')

    # Initialize a SES client
    ses = boto3.client('ses', region_name='us-east-1')

    # Parse the order ID and new status from the event body
    body = json.loads(event['body'])
    order_id = body['order_id']
    new_status = body['new_status']

    try:
        response = table.get_item(Key={'order_id': order_id})

        if 'Item' in response:
            item = response['Item']
            email_recipient = item.get('email')
            if email_recipient is None:
                raise ValueError("No email address associated with the order")

            if new_status == 'Ready':
                email_subject = "Order Status Update"
                email_body = f"Your order {order_id} is now Ready."
                email_source = "cloudbridgega@gmail.com"  

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
        else:
            raise ValueError("Order does not exist")

    except ClientError as e:
        print(e.response['Error']['Message'])
        response_body = "Failed to update order"
        status_code = 500
    except ValueError as e:
        print(e)
        response_body = str(e)
        status_code = 500

    return {
        'statusCode': status_code,
        'body': json.dumps(response_body)
    }