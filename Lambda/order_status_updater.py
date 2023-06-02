import json
import boto3

def handler(event, context):
    print(f"Received event: {json.dumps(event)}")
    
    # Create an SES client
    ses = boto3.client('ses')

    for record in event['Records']:
        if record['eventName'] == 'MODIFY':
            new_image = record['dynamodb']['NewImage']

            # Get the email address and status from the modified record
            email = new_image['email']['S']
            status = new_image['status']['S']

            # Create the message
            subject = 'Order Status Update'
            body = f"Your order is now {status}"

            # Send the email
            response = ses.send_email(
                Source='hunter.hartnett.moseley@gmail.com',
                Destination={
                    'ToAddresses': [email]
                },
                Message={
                    'Subject': {
                        'Data': subject
                    },
                    'Body': {
                        'Text': {
                            'Data': body
                        }
                    }
                }
            )

    return {
        'statusCode': 200,
        'body': json.dumps('Order status updated and SES email sent!')
    }
