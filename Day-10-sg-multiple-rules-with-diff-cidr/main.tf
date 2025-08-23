provider "aws" {
  
}

variable "allowed_port" {
    type = map(string)
    default = {
      22 = "10.0.113.0/24"        # SSH (Restrict to office IP)
      80 ="0.0.0.0/0"             # HTTP (Public)
      443   = "0.0.0.0/0"         # HTTPS (Public)
      8080  = "10.0.0.0/16"       # Internal App (Restrict to VPC)
      9000  = "192.168.1.0/24"    # SonarQube/Jenkins (Restrict to VPN)
      3389  = "10.0.1.0/24"
      3306  = "192.168.4.2/32"    #mysql (Restrict to office IP)
    }
}

resource "aws_security_group" "name" {
    name = "terraform-projct-Ganesh"
    vpc_id = "vpc-05e69f4ded9f826ac"
    description = "Allow restricted inbound traffic"

     dynamic "ingress" {
        for_each = var.allowed_port
        content {
          description = "Allow access to port ${ingress.key}"
          from_port = ingress.key
          to_port = ingress.key
          protocol = "tcp"
          cidr_blocks = [ingress.value]
        }
        
      
    }
    egress {
        from_port = 0
        to_port =  0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name= "terraform-project"
    }
}