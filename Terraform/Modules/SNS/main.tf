resource "aws_sns_topic" "order_updates" {
  name              = "order_updates"
  display_name      = "Order Updates"
}
