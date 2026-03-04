###############################################################
# RDS Module — MySQL Multi-AZ (Database Tier)
###############################################################

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.db_subnet_ids
  description = "DB subnet group for ${var.project_name} ${var.environment}"

  tags = { Name = "${var.project_name}-${var.environment}-db-subnet-group" }
}

resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-${var.environment}-db"
  engine            = "mysql"
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  multi_az               = false  # Set true for production
  publicly_accessible    = false
  skip_final_snapshot    = true   # Set false for production
  deletion_protection    = false  # Set true for production

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]

  tags = { Name = "${var.project_name}-${var.environment}-db" }
}
