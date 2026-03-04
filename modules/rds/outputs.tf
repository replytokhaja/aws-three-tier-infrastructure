output "rds_endpoint" { value = aws_db_instance.main.endpoint sensitive = true }
output "rds_id" { value = aws_db_instance.main.id }
output "rds_arn" { value = aws_db_instance.main.arn }
