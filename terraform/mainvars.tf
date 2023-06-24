variable "WEBHOOK_SIGNATURE_KEY" {
  description = "The webhook signature key for Square"
  type        = string
  sensitive   = true
}

variable "SQUARE_API_TOKEN" {
  description = "The token for the Square API"
  type        = string
  sensitive   = true
}

variable "WEBHOOK_NOTIFICATION_URL" {
  description = "The URL for delivering webhooks"
  type        = string
  sensitive   = true
}