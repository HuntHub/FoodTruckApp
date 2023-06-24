import json
import boto3
import os
import hashlib
import hmac
import base64

webhook_signature_key = os.environ.get('WEBHOOK_SIGNATURE_KEY')

def is_valid_callback(signature_header_value, string_to_sign):
    # Create a HMAC-SHA256 hash of the string_to_sign
    hash = hmac.new(bytes(webhook_signature_key, 'utf-8'), string_to_sign.encode('utf-8'), hashlib.sha256)

    # Compare the original signature to the one you just created
    return hmac.compare_digest(signature_header_value, hash.hexdigest())

def handler(event, context):
    print(f"Received event: {json.dumps(event)}")
    
    # Obtain Square-Signature header
    signature_header_value = event['headers'].get('Square-Signature')

    # Concatenate your notification URL, the timestamp, and the body of the notification
    string_to_sign = event['headers']['Host'] + event['path'] + event['headers']['x-square-signature'] + event['body']

    # Verify the message
    if not is_valid_callback(signature_header_value, string_to_sign):
        print("Failed to verify callback")
        return {
            'statusCode': 403,
            'body': 'Failed to verify callback'
        }
    
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