output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.test.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.test.private_ip
}