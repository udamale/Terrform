
#creation of vpc
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="custome-vpc"
  }
}

# creation of subnet 
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name="cust-vpc-public-subnet"
    }
  
}




# creation of Intrnet getway
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name="custo_ig"
    } 
}

# creation of route table and edit route 
resource "aws_route_table" "name" {
  vpc_id= aws_vpc.name.id
  tags = {
    Name="public-rt"
  }

  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.name.id
  }
}

# creation of subnet association
resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}


resource "aws_subnet" "private" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name="cust-vpc-private-subnet"
  }
}

# creation of elastic ip 
resource "aws_eip" "name" { 
  

}
#  Creation of natgetway 
resource "aws_nat_gateway" "name" {
  allocation_id = aws_eip.name.id
  subnet_id = aws_subnet.name.id
  tags = {
    Name ="nat-gt"
  }
}

#creation of private route-table
resource "aws_route_table" "private" {
 vpc_id = aws_vpc.name.id
 tags = {
   Name="private-rt"
 }
 route {
  cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.name.id
 }
}

# creation of private subnet association
resource "aws_route_table_association" "privateass" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
# creation of securty group
resource "aws_security_group" "allow_tls" {
   name = "allow tls"
   vpc_id = aws_vpc.name.id
   tags = {
     Name="custome_sg"
   }
   ingress {
    description =  "TLS form vpc"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
    description =  "TLS form vpc"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
    description =  "TLS form vpc"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
    from_port = 0
    to_port = 0
    protocol = -1 # all protocol
    cidr_blocks = ["0.0.0.0/0"]
   }
}

# createion  of ec2 instance 
resource "aws_instance" "name" {
    ami = "ami-0861f4e788f5069dd"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.name.id
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
  
}