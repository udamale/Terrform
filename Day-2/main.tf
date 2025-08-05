resource "aws_instance" "name" {
    ami = "ami-0d0ad8bb301edb745"
    instance_type = "t2.micro"
    subnet_id = "subnet-0492674c95b731151"
  
}