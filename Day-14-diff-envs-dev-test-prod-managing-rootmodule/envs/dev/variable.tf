variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "availability_zone" {}
variable "instance_type" {}
variable "env" {}
variable "ami_id" {}
variable "region" {}
variable "vpc_id" {
  type        = string
  description = "VPC ID where SG will be created"
}

variable "allowed_port" {
  type = map(string)
  description = "Map of allowed ports to CIDR ranges"
}