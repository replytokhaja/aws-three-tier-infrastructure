variable "project_name" { type = string }
variable "environment" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "ec2_sg_id" { type = string }
variable "instance_type" { type = string }
variable "ami_id" { type = string default = "" }
variable "key_name" { type = string default = "" }
variable "min_size" { type = number }
variable "max_size" { type = number }
variable "desired_capacity" { type = number }
variable "target_group_arn" { type = string }
