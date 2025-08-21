module "vpc" {
  source = "./module/vpc"
  cidr_block = "10.0.0.0/16"
  subnet_cider_block = "10.0.1.0/24"
  az = "ap-south-1a"
}

module "ec2" {
  source = "./module/ec2"
ami_id = "ami-0861f4e788f5069dd"
instance_type = "t2.micro"
subnet_id = module.vpc.subnet_id
}


module "rds" {
  source         = "./module/rds"
  subnet_id      = module.vpc.subnet_id
  instance_class = "db.t3.micro"
  db_name        = "mydb"
  db_user        = "admin"
  db_password    = "Admin12345"
}
