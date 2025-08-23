

provider "aws" {
  region = var.aws_region
}

module "user_policy" {
  for_each = var.users
  source = "./module/iam"

  user_name        = each.key
  policy_name      = each.value.policy_name
  policy_actions   = each.value.policy_actions
  policy_resources = each.value.policy_resources
}

# Outputs for verification
output "created_users" {
  value = { for k, m in module.user_policy : k => m.user_name }
}

output "created_policies" {
  value = { for k, m in module.user_policy : k => m.policy_arn }
}
