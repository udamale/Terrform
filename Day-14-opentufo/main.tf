provider "aws" {
  
}
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="Myvpc"
  }
  
}

resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name="public-subnet 1a"
  }
}
resource "aws_s3_bucket" "name" {
  bucket = "udamale.xyz"
}