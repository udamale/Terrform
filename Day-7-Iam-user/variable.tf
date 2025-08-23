variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "users" {
  type = map(object({
    policy_name      : string
    policy_actions   : list(string)
    policy_resources : list(string)
  }))
  description = "Map of user configurations for dynamic creation"
}
