provider "aws" {
  
}
data "aws_subnet" "name" {
  filter {
    name = "tag:Name"
    values = ["public_sub"]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Name"
    values = ["private_subnet"]
  }
}

# data "aws_subnet" "private" {
#     filter {
#       name = "tag:name"
#       values = [ "public-subnet-1-1a" ]
#     }
  
# }

data "aws_vpc" "name" {
  tags = {
    Name = "main_vpc"
  }
}


# data "aws_ami" "name" {
#   most_recent = true
#   owners = [ "self" ]
#   filter {
#     name = "name"
#     values = [ "cust" ]
#   }
# }

resource "aws_security_group" "name" {
    vpc_id = data.aws_vpc.name.id
  name = "terraform-project"
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
    Name = "terraform-project"
  }
}
resource "aws_instance" "server" {
  ami = "ami-0861f4e788f5069dd"
  subnet_id = data.aws_subnet.name.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.name.id ]
  associate_public_ip_address = true

  tags = {
    Name= "web server"
  }
  user_data = file("test.sh")
}

resource "aws_lb_target_group" "name" {
    depends_on = [ aws_instance.server ]
  name = "web-server-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.name.id

  target_group_health {
    dns_failover {
      minimum_healthy_targets_count = "1"
      minimum_healthy_targets_percentage = "off"
    }
    unhealthy_state_routing {
      minimum_healthy_targets_count = "1"
      minimum_healthy_targets_percentage = "off"
    }
  }
}
resource "aws_lb_target_group_attachment" "attach_server" {
  target_group_arn = aws_lb_target_group.name.arn
  target_id        = aws_instance.server.id
  port             = 80  # Optional: port on which instance receives traffic
}


resource "aws_lb" "name" {
    depends_on = [ aws_lb_target_group.name ]
  name = "server-alb"
  internal = false
  load_balancer_type = "application"
 security_groups = [ aws_security_group.name.id ]
subnets = concat(
    [data.aws_subnet.name.id],
    data.aws_subnets.private_subnets.ids
  )

#  access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }
}

resource "aws_lb_listener" "web_server" {
    depends_on = [ aws_lb.name ]
    load_balancer_arn = aws_lb.name.arn
    port = "80"
    protocol = "HTTP"

     default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.name.arn
  }
  
}

output "load_balancer_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.name.dns_name
}
