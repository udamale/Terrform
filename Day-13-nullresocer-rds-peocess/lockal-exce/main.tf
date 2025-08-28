provider "aws" {
  
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
    values = ["public-subnet-1-1a"]
  }
}

resource "aws_db_subnet_group" "name" {
  name       = "mysubnet"
  subnet_ids = [
    data.aws_subnet.public_sub.id,
    data.aws_subnet.private_subnet.id,
  ]

  tags = {
    Name = "lockl subnet group"
  }
}


data "aws_secretsmanager_secret_version" "name" {
  secret_id = "Rds_secret"
}

locals {
  rds_credentials =jsondecode(data.aws_secretsmanager_secret_version.name.secret_string)
}

resource "aws_db_instance" "mysql_rds" {
  identifier = "databases1"
  engine = "mysql"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  username = local.rds_credentials.usernaem
  password = local.rds_credentials.password
  db_name = "dev"
  publicly_accessible = true
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.name.name
  
}

resource "null_resource" "local_sql_exce" {
  depends_on = [ aws_db_instance.mysql_rds ]

  provisioner "local-exec" {
    command = "mysql -h ${aws_db_instance.mysql_rds.address} -u ${local.rds_credentials.usernaem} -p ${local.rds_credentials.password} dev <test.sql"
  }
  triggers = {
    always_run =timestamp()
  }
}
