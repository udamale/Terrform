resource "aws_instance" "name" {
    ami = "ami-0b982602dbb32c5bd"
    instance_type = "t2.micro"
    subnet_id = "subnet-0492674c95b731151"
  
}
