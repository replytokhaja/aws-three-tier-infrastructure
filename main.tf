###############################################################
# AWS Three-Tier Infrastructure — Root Module
# Author: Mohammed Khaja
# Description: Production-grade 3-tier AWS architecture using
#              Terraform modules (VPC, ALB, EC2 ASG, RDS)
###############################################################

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Optional: Uncomment to store state in S3
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "three-tier/dev/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Mohammed Khaja"
    }
  }
}

###############################################################
# VPC MODULE
###############################################################
module "vpc" {
  source = "./modules/vpc"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
}

###############################################################
# SECURITY GROUPS MODULE
###############################################################
module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = var.vpc_cidr
}

###############################################################
# APPLICATION LOAD BALANCER MODULE
###############################################################
module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
}

###############################################################
# EC2 AUTO SCALING GROUP MODULE
###############################################################
module "ec2" {
  source = "./modules/ec2"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id          = module.security_groups.ec2_sg_id
  instance_type      = var.instance_type
  ami_id             = var.ami_id
  min_size           = var.asg_min_size
  max_size           = var.asg_max_size
  desired_capacity   = var.asg_desired_capacity
  target_group_arn   = module.alb.target_group_arn
  key_name           = var.key_name
}

###############################################################
# RDS MODULE
###############################################################
module "rds" {
  source = "./modules/rds"

  project_name    = var.project_name
  environment     = var.environment
  db_subnet_ids   = module.vpc.db_subnet_ids
  rds_sg_id       = module.security_groups.rds_sg_id
  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password
  db_instance_class = var.db_instance_class
  db_engine_version = var.db_engine_version
}
