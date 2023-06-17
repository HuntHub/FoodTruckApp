import json
import boto3
import os

def handler(event, context):
    print(f"Received event: {json.dumps(event)}")

    sqs = boto3.client('sqs')
    
    # Get the Queue URL from the environment variables
    queue_url = os.getenv('QUEUE_URL')
    
    # Parse the event body from the event
    body = json.loads(event['body'])
    print(f"Body after JSON load: {json.dumps(body)}") 

    # Extract payment object from the body
    payment = body.get('data', {}).get('object', {}).get('payment')

    if payment is None:
        return {
            'statusCode': 400,
            'body': json.dumps("No 'payment' object in event body.")
        }

    customer_id = payment.get('customer_id')
    
    if customer_id is None:
        return {
            'statusCode': 400,
            'body': json.dumps("No 'customer_id' key in the payment object.")
        }

    # Send the customer_id to the SQS queue
    sqs.send_message(
        QueueUrl=queue_url,  
        MessageBody=json.dumps({'customer_id': customer_id})
    )

    return {
        'statusCode': 200,
        'body': json.dumps("Webhook processed successfully.")
    }