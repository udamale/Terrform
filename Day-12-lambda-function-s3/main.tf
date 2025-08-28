

provider "aws" {
   # or your preferred region
}

# 1. Create an S3 bucket for storing the Lambda deployment packages
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "udamale.xyz"  # must be globally unique
  
}

# 2. Archive your local code into a zip
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_file = "app.py"        # or path to source directory
#   output_path = "lambda_deploy.zip"
# }

# 3. Upload the zipped code to S3
resource "aws_s3_object" "lambda_zip_object" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "app.zip"
  source = "app.zip"
  etag = filemd5("app.zip")

  # Exports a hash to detect updates
  # See below for usage
}

# 4. IAM role for Lambda execution
data "aws_iam_policy_document" "assume_lambda" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 5. Create the Lambda function using the S3 bucket and object
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  runtime       = "python3.13"
  handler       = "app.lambda_handler"
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_zip_object.key
  source_code_hash = aws_s3_object.lambda_zip_object.source_hash

  timeout = 900
}
