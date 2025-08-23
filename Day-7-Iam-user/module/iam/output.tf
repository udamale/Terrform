output "user_name" {
  value       = aws_iam_user.user.name
  description = "The IAM user name"
}

output "policy_arn" {
  value       = aws_iam_policy.policy.arn
  description = "The created policy ARN"
}
