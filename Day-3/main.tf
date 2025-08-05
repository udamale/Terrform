resource "aws_instance" "name" {
 ami = var.ami-id
    instance_type = var.type
    subnet_id = "subnet-0492674c95b731151"
}