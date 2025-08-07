resource "aws_instance" "name" {
  ami = "ami-0d54604676873b4ec"
  instance_type = "t2.micro"
  subnet_id = "subnet-0492674c95b731151"
  tags = {
    Name ="devloper"
  }

}

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name= "terraform vpc"
    }
  
}