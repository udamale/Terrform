
#creation of vpc
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="custome-vpc"
  }
}

# creation of subnet 
resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    tags = {
      Name="cust-vpc-public-subnet1-1a" 
    }
  
}
resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "ap-south-1b"
    tags = {
      Name="cust-vpc-public-subnet2-1b" 
    }
  
}




# creation of Intrnet getway
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name="cust_ig"
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
resource "aws_route_table_association" "public" {
  for_each = { 
    public1 = aws_subnet.public1.id
    public2 = aws_subnet.public2.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.name.id
}


  #private subnet inside cust vpc
resource "aws_subnet" "private1" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name="cust-vpc-private-subnet-1-1a"
  }
}

resource "aws_subnet" "private2" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name="cust-vpc-private-subnet-2-1b"
  }
}
resource "aws_subnet" "private3" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name="cust-vpc-private-subnet-3-1a"
  }
}

resource "aws_subnet" "private4" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name="cust-vpc-private-subnet-4-1b"
  }
}

# creation of elastic ip 
resource "aws_eip" "name" { 
  

}
#  Creation of natgetway 
resource "aws_nat_gateway" "name" {
  allocation_id = aws_eip.name.id
  subnet_id = aws_subnet.public1.id
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
   for_each = { 
   private1=aws_subnet.private1.id
   private2=aws_subnet.private2.id
   private3=aws_subnet.private3.id
   private4=aws_subnet.private4.id   
  }
  subnet_id = each.value  
  route_table_id = aws_route_table.private.id
}
# creation of securty group
resource "aws_security_group" "name" {
    vpc_id = aws_vpc.name.id
 
  description = "Allow TLS inbound traffic"

        ingress = [
        for port in [22, 80, 443, 8080, 9000, 3000, 8082, 8081 ,8000] : {
        description      = "inbound rules"
        from_port        = port
        to_port          = port
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks=[]
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        }
    ]

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "cust-project"
  }
}

# createion  of ec2 instance 
resource "aws_instance" "public" {
    ami = "ami-0861f4e788f5069dd"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public1.id
     associate_public_ip_address = true
      vpc_security_group_ids = [aws_security_group.name.id]
      tags = {
        Name="public server"
      }
      
  
}

resource "aws_instance" "frotend" {
    ami = "ami-0861f4e788f5069dd"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private1.id
      vpc_security_group_ids = [aws_security_group.name.id]
      tags = {
        Name="frotend server"
      }  
}


resource "aws_instance" "backend" {
    ami = "ami-0861f4e788f5069dd"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private2.id
      vpc_security_group_ids = [aws_security_group.name.id]
      tags = {
        Name="Backend server"
      }  
}

resource "aws_instance" "Grafan" {
    ami = "ami-0861f4e788f5069dd"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private3.id
      vpc_security_group_ids = [aws_security_group.name.id]
      tags = {
        Name="Grafan server"
      }  
}