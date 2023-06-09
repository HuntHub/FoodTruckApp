output "sqs_dead_letter_queue_arn" {
  description = "The ARN of the SQS dead letter queue"
  value       = aws_sqs_queue.dead_letter_queue.arn
}

output "sqs_dead_letter_queue_url" {
   description = "The URL of the SQS dead letter queue"
   value = aws_sqs_queue.dead_letter_queue.url
}   