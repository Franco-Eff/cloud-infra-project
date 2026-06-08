output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.main.id
}
