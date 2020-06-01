provider "aws" {
  version    = "~> 2.0"
  region     = var.aws_region
  access_key = "AKIAXAX23PMHLRXOQU72"
  secret_key = "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"
}

resource "aws_vpc" "udacity" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "udacity"
  }
}

resource "aws_subnet" "udacity_subnet1" {
  depends_on              = [aws_vpc.udacity]
  vpc_id                  = aws_vpc.udacity.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "udacity"
  }
}

data "aws_subnet" "selected_subnet" {
  vpc_id = "vpc-a02c7dda"
  id     = "subnet-29929475"
}

resource "aws_iam_role_policy" "cloudwatch_policy" {
  name = "cloudwatch_policy"
  role = aws_iam_role.iam_for_lambda.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*",
        "Effect": "Allow"
        }
    ]
  }
  EOF
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda_function" {
  filename      = "greet_lambda.zip"
  function_name = "greet_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "greet_lambda.lambda_handler"

  source_code_hash = filebase64sha256("greet_lambda.zip")

  runtime = "python3.8"

  environment {
    variables = {
      greeting = "Hi Terraform"
    }
  }
}
