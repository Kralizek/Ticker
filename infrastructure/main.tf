variable "profile" {
    type = string
}

provider "aws" {
    region = "eu-north-1"
    profile = var.profile
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }  
}

resource "aws_iam_role" "this" {
    name = "ticker"
    description = "Role for Ticker Lambda function"
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
        "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    ]
    assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_ecr_repository" "this" {
    name = "samples/ticker"
}

resource "aws_cloudwatch_log_group" "this" {
    name = "/aws/lambda/${aws_lambda_function.this.function_name}"
    retention_in_days = 14
}

resource "aws_lambda_function" "this" {
    function_name = "ticker"
    role = aws_iam_role.this.arn
    package_type = "Image"
    image_uri = "${aws_ecr_repository.this.repository_url}:latest"
}

resource "aws_cloudwatch_event_rule" "this" {
    name = "ticker-event"
    schedule_expression = "rate(1 minute)"
    depends_on = [aws_lambda_function.this]
}

resource "aws_cloudwatch_event_target" "this" {
    arn = aws_lambda_function.this.arn
    rule = aws_cloudwatch_event_rule.this.id
}

resource "aws_lambda_permission" "this" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.this.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.this.arn
}