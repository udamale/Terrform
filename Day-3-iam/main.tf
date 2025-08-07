provider "aws" {
 
}

# 1. Custom IAM Policy definition (inline)
resource "aws_iam_policy" "custom_policy" {
  name        = "${var.role_name}-policy"
  description = "Custom policy for EC2 instance"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:Describe*",
          "cloudwatch:ListMetrics",
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = "*"
      }
    ]
  })
}

# 2. Trust policy allowing EC2 to assume the role
data "aws_iam_policy_document" "trust_ec2" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# 3. IAM Role resource
resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust_ec2.json
  description        = "Role for EC2, created via Terraform"
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 4. Attach the custom policy to the role
resource "aws_iam_role_policy_attachment" "attach_custom" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.custom_policy.arn
}

# 5. Optionally attach AWS-managed policy too, e.g. S3 ReadOnly
resource "aws_iam_role_policy_attachment" "attach_s3_readonly" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# 6. Create instance profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.role.name
}

# 7. EC2 instance with IAM instance profile
resource "aws_instance" "test" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  tags = {
    Name = "test"
  }

  # optional user_data
  # user_data = <<-EOF
  #   #!/bin/bash
  #   yum install -y awscli
  # EOF
}

output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.role.arn
}

output "instance_profile_name" {
  description = "IAM instance profile name"
  value       = aws_iam_instance_profile.instance_profile.name
}

output "ec2_instance_id" {
  description = "ID of EC2 instance"
  value       = aws_instance.test.id
}

output "ec2_private_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.test.private_ip
}
