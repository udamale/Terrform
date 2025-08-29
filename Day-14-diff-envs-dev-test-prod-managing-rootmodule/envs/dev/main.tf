

provider "aws" {
  region = var.region
  #profile = "dev"
}

module "vpc" {
  source              = "../../modules/vpc"
  cidr_block          = var.vpc_cidr             # ✅ Correct name
  availability_zone   = var.availability_zone      # ✅ Correct name
  public_subnet_cidr  = var.public_subnet_cidr     # ✅ Correct name
  env                 = var.env
}

module "ec2" {
  source        = "../../modules/ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  env           = var.env
 subnet_id     = module.vpc.public_subnet_id
  
}

module "sec_group" {
  source      = "../../modules/sg"
  depends_on = [ aws_vpc ]
  vpc_id      = var.vpc_id
  sg_name     = "terraform-project-Ganesh"
  allowed_port = var.allowed_port
}

output "aws_vpc" {
  value = var.vpc_id
}

