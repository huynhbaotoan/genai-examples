# Configure the AWS provider
provider "aws" {
  region = var.region
}

# Fetch information about each foundation model
data "aws_bedrock_foundation_model" "foundation_models" {
  count = length(var.foundation_models)
  model_id = var.foundation_models[count.index]
}

# Create provisioned throughput for each model
resource "aws_bedrock_provisioned_model_throughput" "model_throughputs" {
  count                  = length(var.foundation_models)
  provisioned_model_name = "model-${var.foundation_models[count.index]}"
  model_arn               = data.aws_bedrock_foundation_model.foundation_models[count.index].model_arn
  model_units            = 1
}

# IAM Role for Bedrock
resource "aws_iam_role" "bedrock_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Bedrock
resource "aws_iam_role_policy" "bedrock_policy" {
  name = var.iam_policy_name
  role = aws_iam_role.bedrock_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:ListFoundationModels"
        ]
        Resource = "*"
      }
    ]
  })
}