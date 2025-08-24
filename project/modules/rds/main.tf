resource "aws_db_subnet_group" "this" {
  name        = "${var.identifier}-subnet-group"
  description = "RDS subnet group for ${var.identifier}"
  subnet_ids  = values(aws_subnet.private)[*].id
  tags = {
    Name = "${var.identifier}-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier             = var.identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  username               = var.username
  password               = var.password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids

  skip_final_snapshot    = true
  publicly_accessible    = false

  depends_on = [aws_db_subnet_group.this]
}
