provider "aws" {
  
}
resource "aws_instance" "test" {
  ami = var.ami-id
  instance_type = var.instance_type
  subnet_id = var.subnet-id
  tags = {
    Name="test-server"
  }
}