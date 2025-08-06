variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0d54604676873b4ec"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
  default     = "subnet-0492674c95b731151"
}

variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = "example-ec2-role"
}

variable "instance_profile_name" {
  description = "Name of IAM instance profile"
  type        = string
  default     = "example-instance-profile"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}
