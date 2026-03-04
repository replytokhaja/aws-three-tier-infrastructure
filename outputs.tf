###############################################################
# Root Outputs
###############################################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB (for Route 53)"
  value       = module.alb.alb_zone_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "db_subnet_ids" {
  description = "IDs of database subnets"
  value       = module.vpc.db_subnet_ids
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.rds_endpoint
  sensitive   = true
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.ec2.asg_name
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}
