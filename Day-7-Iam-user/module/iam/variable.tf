variable "user_name" {
  type        = string
  description = "Name of the IAM user"
}

variable "policy_name" {
  type        = string
  description = "Name of the policy to create"
}

variable "policy_actions" {
  type        = list(string)
  description = "List of IAM actions for the policy"
}

variable "policy_resources" {
  type        = list(string)
  description = "List of resources the policy applies to"
}
