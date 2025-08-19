provider "aws" {
  
}

resource "aws_instance" "name" {
    ami = "ami-0861f4e788f5069dd"
    instance_type = "t2.micro"
    subnet_id = "subnet-09f113a76bbdf6b91"  
    tags = {
      Name= "test"
    }

    lifecycle {
     # prevent_destroy = true
      ignore_changes = [ tags ]

    }
}