variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of availability zones for subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "allow_ports" {
  description = "List of ports to allow inbound in the security group"
  type        = list(number)
  default     = [22, 80, 443, 8080, 3000, 9000]
}

variable "ami" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0861f4e788f5069dd"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}



#creating for rds variable and calling value from terraform.tfvars

#variable "rds_instances" {
 # type = map(object({
  #  engine             = string
  # engine_version     = string
  #  instance_class     = string
  #  allocated_storage  = number
  #  username           = string
  # password           = string
  #  subnet_ids         = list(string)
  #  vpc_sg_ids         = list(string)
 # }))
#}





#creation of iam user variable and calling value from terraform.tfvars

variable "users" {
  type = map(object({
    policy_name      : string
    policy_actions   : list(string)
    policy_resources : list(string)
  }))
  description = "Map of user configurations for dynamic creation"
}
