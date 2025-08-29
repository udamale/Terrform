resource "aws_security_group" "this" {
  name        = var.sg_name
  vpc_id      = var.vpc_id
  description = "Allow restricted inbound traffic"

  dynamic "ingress" {
    for_each = var.allowed_port
    content {
      description = "Allow access to port ${ingress.key}"
      from_port   = tonumber(ingress.key)
      to_port     = tonumber(ingress.key)
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}

