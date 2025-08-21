resource "aws_vpc" "name" {
    cidr_block = var.cidr_block
    tags = {
      Name ="terraform_vpc"
    }
  
}

resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.subnet_cider_block
  availability_zone = var.az

  tags = {
    Name ="terraform_vpc"
  }
}

output "subnet_id" {
  value = aws_subnet.name.id
}