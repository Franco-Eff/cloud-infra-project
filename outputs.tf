# The name of the S3 bucket — used to reference the bucket in other services
output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket
}

# The unique AWS identifier for the S3 bucket
output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}

# The ID of the VPC — used to reference the network in other resources
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# The ID of the public subnet — useful for launching additional resources
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

# The public IP of the EC2 instance — use this to SSH into the server
output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.main.public_ip
}

# The unique AWS ID of the EC2 instance
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.main.id
}

# The name of the stop Lambda function
output "stop_lambda_function_name" {
  description = "The name of the EC2 stop Lambda function"
  value       = aws_lambda_function.stop_ec2.function_name
}

# The name of the start Lambda function
output "start_lambda_function_name" {
  description = "The name of the EC2 start Lambda function"
  value       = aws_lambda_function.start_ec2.function_name
}
