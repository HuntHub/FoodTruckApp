resource "aws_sqs_queue" "dead_letter_queue" {
  name = "my_dead_letter_queue"
}
