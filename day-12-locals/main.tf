locals {
  region ="ap-south-1"
  instance_type="t2.micro"
  subnet_id="subnet-09f113a76bbdf6b91"
}

provider "aws" {
  region = local.region
}

resource "aws_instance" "name" {
  ami = "ami-0861f4e788f5069dd"
  instance_type = local.instance_type
  subnet_id = local.subnet_id
  }



#   What Is a locals Block?

# In Terraform, a locals block lets you define local values within a module—similar to internal variables in a function. 

# These values are:
# Internal: They can only be used within the module where they’re defined.
# Immutable per run: Once Terraform evaluates them during planning, their values remain fixed throughout the lifecycle of that run 
# Not user-configurable: Unlike input variables set by users, locals must be set directly in your configuration

# Quick Recap

# What: locals blocks define internal, immutable values for use within a module.

# Why: To reduce duplication, improve readability, and centralize complex logic.

# How: Declare in a locals { ... } block and reference via local.<name>.

# Best Practice: Use thoughtfully and complement—not replace—input variables.