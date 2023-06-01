import json
import boto3

def handler(event, context):
    print(f"Received event: {json.dumps(event)}")
    
    # Create an SNS client
    sns = boto3.client('sns')

    for record in event['Records']:
        if record['eventName'] == 'MODIFY':
            new_image = record['dynamodb']['NewImage']

            # Get the phone number and status from the modified record
            phone_number = new_image['phone_number']['S']
            status = new_image['status']['S']

            # Create the message
            message = f"Your order is now {status}"

            # Publish the message to the SNS topic
            response = sns.publish(
                PhoneNumber=phone_number,
                Message=message
            )

    return {
        'statusCode': 200,
        'body': json.dumps('Order status updated and SNS notification sent!')
    }
