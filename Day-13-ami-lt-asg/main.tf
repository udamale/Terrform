provider "aws" {
  
}

data "aws_subnet" "name" {
  filter {
    name = "tag:name"
    values = [ "public_sub" ]
  }
}

data "aws_subnet" "private" {
    filter {
      name = "tag:name"
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

resource "aws_instance" "server" {
  ami = data.aws_ami.name.id
  subnet_id = data.aws_ami.name.id
  instance_type = "t2.micro"
  associate_public_ip_address = true

  tags = {
    Name= "web server"
  }
  user_data = file("test.sh")
}

resource "aws_ami_from_instance" "name" {
    source_instance_id = aws_instance.server.id
    name = "web server"
    snapshot_without_reboot = true
  
}


resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = aws_ami_from_instance.name.id
  instance_type = "t2.micro"

  network_interfaces {
    subnet_id              = data.aws_subnet.name.id
    associate_public_ip_address = true
  }

  user_data = filebase64("test.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WebServerFromLT"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name_prefix          = "my-asg-"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2

  # Specify the Launch Template to use
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = aws_launch_template.web_lt.latest_version
  }

  # Subnets for scaling instances
  vpc_zone_identifier = [
    data.aws_subnet.name.id,
    # Add more subnet IDs as needed
  ]

  # Optional: ALB integration for load balancing
  target_group_arns = [
    aws_lb_target_group.my_alb_tg.arn,
  ]

  health_check_type         = "EC2"
  health_check_grace_period = 300

  # Optional: Rolling updates when the template is updated
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 300
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "ASG-Instance"
    propagate_at_launch = true
  }
}



