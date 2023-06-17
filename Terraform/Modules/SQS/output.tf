output "order_queue_arn" {
  description = "The ARN of the order queue"
  value       = aws_sqs_queue.order_events.arn
}

output "order_queue_url" {
   description = "The URL of the order queue"
   value = aws_sqs_queue.order_events.url
}