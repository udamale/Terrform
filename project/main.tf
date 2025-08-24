

provider "aws" {
  region = var.aws_region
}

# ──────────────── Network Module ────────────────
module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  allow_ports          = var.allow_ports
}

# ──────────────── EC2 Instance Modules ────────────────
module "public_server" {
  source              = "./modules/ec2_instance"
  subnet_id           = module.network.public_subnets[0]
  ami                 = var.ami
  instance_type       = var.instance_type
  associate_public_ip = true
  security_group_ids  = [module.network.security_group_id]
  instance_name       = "public-server"
}

module "frontend_server" {
  source              = "./modules/ec2_instance"
  subnet_id           = module.network.private_subnets[0]
  ami                 = var.ami
  instance_type       = var.instance_type
  associate_public_ip = false
  security_group_ids  = [module.network.security_group_id]
  instance_name       = "frontend-server"
}

module "backend_server" {
  source              = "./modules/ec2_instance"
  subnet_id           = module.network.private_subnets[1]
  ami                 = var.ami
  instance_type       = var.instance_type
  associate_public_ip = false
  security_group_ids  = [module.network.security_group_id]
  instance_name       = "backend-server"
}

# ──────────────── Outputs ────────────────
output "vpc_id" {
  description = "ID of the provisioned VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.network.public_subnets
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.network.private_subnets
}

output "public_server_id" {
  description = "ID of the public EC2 instance"
  value       = module.public_server.instance_id
}

output "frontend_server_id" {
  description = "ID of the frontend EC2 instance"
  value       = module.frontend_server.instance_id
}

output "backend_server_id" {
  description = "ID of the backend EC2 instance"
  value       = module.backend_server.instance_id
}


# ──────────────── #creaing rds ────────────────


#module "rds" {
#  source   = "./modules/rds"
 # for_each = var.rds_instances

 # identifier              = each.key
 # engine                  = each.value.engine
 # engine_version          = each.value.engine_version
 # instance_class          = each.value.instance_class
 # allocated_storage       = each.value.allocated_storage
 # username                = each.value.username
 # password                = each.value.password
#  subnet_ids              = each.value.subnet_ids
#  vpc_security_group_ids  = each.value.vpc_sg_ids
#}

# ──────────────── #user_policy ────────────────
#creation of iam user and attache to policy
module "user_policy" {
  for_each = var.users
  source = "./modules/iam"

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
