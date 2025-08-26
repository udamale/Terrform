provider "aws" {
  
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


data "archive_file" "zipfile" {
  type = "zip"
  source_file = "app.py"
  output_path = "app.py.zip"  
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          =  aws_iam_role.lambda_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.13"
  timeout       = 420

  memory_size   = 128

  filename         = data.archive_file.zipfile.output_path # Ensure this file exists
  source_code_hash = filebase64sha256("app.py.zip")

  #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

#This hash is a checksum that triggers a deployment.
}

