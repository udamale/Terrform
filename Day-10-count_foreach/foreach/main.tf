provider "aws" {
  
}


resource "aws_instance" "name" {
  ami = "ami-0861f4e788f5069dd"
  instance_type = "t2.micro"
   subnet_id = "subnet-09f113a76bbdf6b91"
  for_each = toset(var.ec2)
#  count = length(var.ec2)

  tags = {
    Name =each.value
  }
}

variable "ec2" {
  type = list(string)
  default = [ "test",  "dev","prod"]
}