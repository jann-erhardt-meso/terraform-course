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

resource "aws_iam_role" "iam_for_lambda" {
  name_prefix        = var.lambda_function_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir = "${path.module}/files/hello-world"
  output_path = "${path.module}/${var.lambda_function_name}.zip"
}

resource "aws_lambda_function" "this" {
  filename      = data.archive_file.lambda.output_path
  function_name = var.lambda_function_name
  handler       = "main.handler"
  role          = aws_iam_role.iam_for_lambda.arn
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime = "python3.11"
}

resource "aws_lambda_invocation" "this" {
  function_name = aws_lambda_function.this.function_name

  triggers = {
    redeployment = timestamp() # Always invoke lambda
  }

  input = jsonencode({
    name = "Jann"
  })
}