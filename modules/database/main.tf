# RDS MySQL Instance
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  identifier = "${var.project}-${var.environment}-rds"
  engine     = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.medium"

  allocated_storage    = 20
  max_allocated_storage = 100

  db_name  = "acme_db"
  username = "admin"
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  subnet_ids             = var.private_subnets

  multi_az = true

  storage_encrypted = true

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.project}-${var.environment}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    description      = "MySQL access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.ec2_sg.id, aws_security_group.ecs_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# Database password variable (securely manage in secrets manager or as an input variable)
variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}
