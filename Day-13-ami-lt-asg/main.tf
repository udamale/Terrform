provider "aws" {
  
}
# data source block of public subnet
data "aws_subnet" "name" {
  filter {
    name = "tag:Name"
    values = [ "public_sub" ]
  }
}

data "aws_subnet" "private" {
    filter {
      name = "tag:Name"
      values = [ "public-subnet-1-1a" ]
    }
  
}

data "aws_ami" "name" {
  most_recent = true
  owners = [ "self" ]
  filter {
    name = "name"
    values = [ "cust" ]
  }
}

data "aws_vpc" "name" {
  tags = {
    Name= "main_vpc"
  }
}

# creation of security group with same cidr
resource "aws_security_group" "name" {
    vpc_id = data.aws_vpc.name.id
  name = "terraform-project"
  description = "Allow TLS inbound traffic"

        ingress = [
        for port in [22, 80, 443, 9000, 3000, 8082, 8081 ,8000] : {
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

#creation of Ec2 server
resource "aws_instance" "server" {
  ami = data.aws_ami.name.id
  subnet_id = data.aws_subnet.name.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.name.id ]
#  associate_public_ip_address = true

  tags = {
    Name= "web server"
  }
  user_data = file("test.sh")
}

# creation of the target group 
resource "aws_lb_target_group" "name" {
  name = "tg-server"
  port = "80"
  protocol = "HTTP"
  vpc_id =data.aws_vpc.name.id

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

# target group attechment to target instace ec2 server   
resource "aws_lb_target_group_attachment" "name" {
  target_group_arn = aws_lb_target_group.name.arn
  target_id = aws_instance.server.id
  port = 80 
}

resource "aws_lb" "name" {
    depends_on = [ aws_lb_target_group.name ]
  name = "server-alb"
  internal = false
  load_balancer_type = "application"
 security_groups = [ aws_security_group.name.id ]
subnets = concat(
  [data.aws_subnet.name.id],
  [data.aws_subnet.private.id]
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

# creation of ami image form instance
resource "aws_ami_from_instance" "name" {
  depends_on = [ aws_instance.server ]
    source_instance_id = aws_instance.server.id
    name = "web server"
    snapshot_without_reboot = true
  
}

# creation of lunche template and attecha to the ami image
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = aws_ami_from_instance.name.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.name.id ]

  # network_interfaces {
  #   subnet_id              = data.aws_subnet.name.id
  #   associate_public_ip_address = true
  # }

  user_data = filebase64("test.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WebServerFromLT"
    }
  }
}


# cretion of asg server and attach to the lunche templet
resource "aws_autoscaling_group" "asg" {
  name_prefix          = "my-asg-"
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1

  # Specify the Launch Template to use
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = aws_launch_template.web_lt.latest_version
  }

  # Subnets for scaling instances
  vpc_zone_identifier = [
    data.aws_subnet.name.id,
    data.aws_subnet.private.id
    # Add more subnet IDs as needed
  ]

  # Optional: ALB integration for load balancing
  target_group_arns = [
    aws_lb_target_group.name.arn
  ]

  health_check_type         = "EC2"
  health_check_grace_period = 100

  # Optional: Rolling updates when the template is updated
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 200
    }
   # triggers = ["launch_template"]          // launch_template' always triggers an instance refres
  }

  tag {
    key                 = "Name"
    value               = "ASG-Instance"
    propagate_at_launch = true
  }
}



