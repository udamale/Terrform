resource "aws_instance" "name" {
  ami = "ami-0d54604676873b4ec"
  instance_type = "t2.micro"
  subnet_id = "subnet-0492674c95b731151"
  tags = {
    Name ="test"
  }
}

