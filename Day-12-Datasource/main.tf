provider "aws" {
  
}

data "aws_subnet" "name" {
  filter {
    name = "tag:Name"
    values = [ "private_subnet" ]
  }
}

# data "aws_ami" "name" {
# most_recent = true
# owners = [ "amazon" ]
# filter {
# name = "name"
# values = [ "amzn2-ami-hvm-*-gp2" ]
# }
# filter {
# name = "root-device-type"
# values = [ "ebs" ]
# }

# filter {
# name = "virtualization-type"
# values = [ "hvm" ]
# }
# filter {
# name = "architecture"
# values = [ "x86_64" ]
# }
# }

data "aws_ami" "name" {
  most_recent = true
  owners = [ "self" ]
  filter {
    name = "name"
    values = [ "cust" ]
  }
}

resource "aws_instance" "name" {
  ami = data.aws_ami.name.id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.name.id

  tags = {
    Name ="ami-server"
  }
}