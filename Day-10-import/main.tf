provider "aws" {
  
}

resource "aws_instance" "name" {
  ami = "ami-0861f4e788f5069dd"
  instance_type = "t2.micro"
  tags = {
    Name="terraform import"
  }
}

#terraform import aws_instance.name i-033cf7d48a9250882  here chage instance id that already exist

resource "aws_s3_bucket" "name" {
    bucket = "udamale.xyz"

}

#  terraform import aws_s3_bucket.name udamale.xyz   here change name that already exist

resource "aws_db_instance" "name" {
    allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0.42"
  instance_class       = "db.t4g.micro"
  db_name              = ""
  username             = "admin"
  password             ="Ganesh$9579"
  db_subnet_group_name = "defult-subnet-group"
  skip_final_snapshot  = true
}
# terraform import aws_db_instance.name database-1   here change database identifier that already exist


resource "aws_iam_user" "name" {
  name = "yogi"
}

# terraform import aws_iam_user.name yogi       here change user name that already exist