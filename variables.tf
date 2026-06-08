variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "A name prefix for all your resources"
  type        = string
  default     = "my-infra-project"
}