provider "aws" {
  
}
#resource "aws_instance" "ec2" {
 #   ami = "ami-0861f4e788f5069dd"
  #  instance_type = "t2.micro"
   # subnet_id = "subnet-09f113a76bbdf6b91"
  #  count = 2
  #  tags = {
  #  Name="test"   same name for two instances "test"
   # Name="test-${count.index}" #differant name for two instances "test-0"  and ""
   # }
#}


variable "ec2" {
  type = list(string)
  default = [ "test","dev","prod" ]
}

resource "aws_instance" "name" {
    ami = "ami-0861f4e788f5069dd"
    instance_type = "t2.micro"
    subnet_id = "subnet-09f113a76bbdf6b91"
    count = length(var.ec2)
    tags = {
      Name= var.ec2[count.index]   # to make them uniquc
    }
}