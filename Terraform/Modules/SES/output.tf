output "ses_email_identity_arn" {
  description = "The ARN of the email identity"
  value       = aws_ses_email_identity.example.arn
}
