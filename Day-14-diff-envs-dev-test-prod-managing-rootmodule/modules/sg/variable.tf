variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "sg_name" {
  type        = string
  description = "Security Group name"
}

variable "allowed_port" {
  type        = map(string)
  description = "Map of ports to allowed CIDR ranges"
}

