# Lambda Function
resource "aws_lambda_function" "function" {
  function_name = "${var.project}-${var.environment}-lambda"
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "path/to/your/lambda/package.zip"

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the role as needed

# Lambda Function Configuration
# Upload your Lambda function code package to S3 or reference local file
