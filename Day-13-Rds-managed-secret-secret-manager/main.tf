provider "aws" {
  # Add AWS provider configuration as needed.
}

data "aws_subnet" "public_sub" {
  filter {
    name   = "tag:Name"
    values = ["public_sub"]
  }
}

data "aws_subnet" "private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["private_subnet"]
  }
}

resource "aws_db_subnet_group" "name" {
  name       = "mysubnet"
  subnet_ids = [
    data.aws_subnet.public_sub.id,
    data.aws_subnet.private_subnet.id,
  ]

  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_db_instance" "name" {
  allocated_storage              = 10
  identifier                     = "ganesh-rds"
  engine                         = "mysql"
  engine_version                 = "8.0"
  db_name                        = "mydb"
  instance_class                 = "db.t3.micro"
  manage_master_user_password    = true
  username                       = "admin"
#  password                       = var.db_password  # Consider moving your password to a sensitive variable
  db_subnet_group_name           = aws_db_subnet_group.name.name  # or .id
  parameter_group_name           = "default.mysql8.0"
  backup_retention_period        = 7
  backup_window                  = "02:00-03:00"
  maintenance_window             = "Sun:04:00-Sun:05:00"
  deletion_protection            = false
  skip_final_snapshot            = true

  depends_on = [aws_db_subnet_group.name]
}
