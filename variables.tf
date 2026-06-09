# The AWS region where all resources will be created
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

# A prefix applied to all resource names for easy identification in AWS
variable "project_name" {
  description = "A name prefix for all your resources"
  type        = string
  default     = "my-infra-project"
}

# The IP range for the entire VPC — contains all subnets
variable "vpc_cidr" {
  description = "The IP address range for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# The IP range for the public subnet — resources here are internet accessible
variable "public_subnet_cidr" {
  description = "The IP address range for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# The IP range for the private subnet — resources here are internal only
variable "private_subnet_cidr" {
  description = "The IP address range for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# The specific data center within us-east-1 to deploy resources in
variable "availability_zone" {
  description = "The availability zone to deploy resources in"
  type        = string
  default     = "us-east-1a"
}

# t3.micro is free tier eligible and enough for this project
variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t3.micro"
}
