provider "aws" {
  
}
# subnet data source
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

# creation fo database subnet group and attach to the two subnet ids
resource "aws_db_subnet_group" "name" {
  name       = "mysubnet"
  subnet_ids = [
    data.aws_subnet.public_sub.id,
    data.aws_subnet.private_subnet.id,
  ]

  tags = {
    Name = " project_subnet_group"
  }
}

# existin secret manager take a secret id
data "aws_secretsmanager_secret_version" "name" {
  secret_id = "Rds_secret"
}

locals {
  rds_credentials =jsondecode(data.aws_secretsmanager_secret_version.name.secret_string)
}

# creation of rds with attacte serete manager value
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

#creation of key pair for instance server
resource "aws_key_pair" "example" {
  key_name   = "task"
  public_key = file("~/.ssh/id_ed25519.pub")
}

data "aws_ami" "name" {
  most_recent = true
  owners = [ "self" ]
  filter {
    name = "name"
    values = [ "cust" ]
  }
}

# creation of ec2 server 
resource "aws_instance" "sql_runner" {
    depends_on = [ aws_db_instance.mysql_rds ]
 ami = data.aws_ami.name.id
 instance_type = "t2.micro"
 key_name = aws_key_pair.example.key_name
 subnet_id = data.aws_subnet.public_sub.id
 associate_public_ip_address = true
 tags = {
   Name ="Sql server"
 }

 user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd mysql-server
    systemctl start httpd
    systemctl enable httpd
    systemctl start mysqld
    systemctl enable mysqld
    echo "<html><body><h1>Web & MySQL Server is Up!</h1></body></html>" > /var/www/html/index.html
  EOF
  
}

resource "null_resource" "local_sql_exce" {
  depends_on = [ aws_instance.sql_runner,aws_db_instance.mysql_rds]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("~/.ssh/id_ed25519")
      host = aws_instance.sql_runner.public_ip
    }

    provisioner "file" {
      source = "test.sql"
      destination = "/tmp/test.sql"
    }

  provisioner "remote-exec" {
    inline = [ 
        "mysql -h ${aws_db_instance.mysql_rds.address} -u ${local.rds_credentials.usernaem} -p ${local.rds_credentials.password} dev < /tmp/test.sql"
     ]
    
  }
  triggers = {
    always_run =timestamp()
  }
}

output "aws_instance" {
  value = aws_instance.sql_runner.public_ip
}

output "aws_db_instance" {
  value = aws_db_instance.mysql_rds.address

}



# resource "null_resource" "local_sql_exec" {
#   depends_on = [aws_instance.sql_runner, aws_db_instance.mysql_rds]

#   connection {
#     type        = "ssh"
#     host        = aws_instance.sql_runner.public_ip
#     user        = "ec2-user"
#     private_key = file("~/.ssh/id_ed25519")
#     timeout     = "1m"
#     script_path = "/home/ec2-user/terraform_exec.sh"  # avoids /tmp issues
#   }

#   provisioner "file" {
#     source      = "test.sql"
#     destination = "/home/ec2-user/test.sql"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "echo \"PATH is: $PATH\"",
#       "which mysql || echo 'mysql not found!'",
#       "mysql -h ${aws_db_instance.mysql_rds.address} -u ${local.rds_credentials.username} -p${local.rds_credentials.password} dev < /home/ec2-user/test.sql"
#     ]
#   }

#   triggers = {
#     always_run = timestamp()
#   }
# }
