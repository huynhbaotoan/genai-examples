# Output the ARN of the IAM role
output "bedrock_role_arn" {
  value = aws_iam_role.bedrock_role.arn
  description = "The ARN of the IAM role for Bedrock"
}
