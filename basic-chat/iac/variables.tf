variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "foundation_models" {
  description = "List of foundation models to grant access to"
  type        = list(string)
  default     = [
    "anthropic.claude-v2",
    "ai21.j2-ultra-v1",
    "amazon.titan-tg1-large"
  ]
}

variable "iam_role_name" {
  description = "Name of the IAM role for Bedrock"
  type        = string
  default     = "bedrock_access_role"
}

variable "iam_policy_name" {
  description = "Name of the IAM policy for Bedrock"
  type        = string
  default     = "bedrock_access_policy"
}