resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip
  vpc_security_group_ids      = var.security_group_ids

  tags = {
    Name = var.instance_name
  }
}


output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.this.id
}

