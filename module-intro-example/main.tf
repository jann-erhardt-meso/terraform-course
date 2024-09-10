data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
}

data "aws_iam_policy_document" "permissions" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name_prefix        = var.function_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "permissions" {
  policy = data.aws_iam_policy_document.permissions.json
  role   = aws_iam_role.iam_for_lambda.id
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir = var.source_dir
  output_path = "${path.module}/${var.function_name}.zip"
}

resource "aws_lambda_function" "this" {
  filename      = data.archive_file.lambda.output_path
  function_name = var.function_name
  handler       = var.handler
  role          = aws_iam_role.iam_for_lambda.arn
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime = var.runtime
  timeout = var.timeout
  environment {
    variables = var.environment_variables
  }
}