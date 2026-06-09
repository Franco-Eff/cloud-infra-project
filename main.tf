# Creates the main VPC that contains all project networking resources 
resource "aws_s3_bucket" "main" {
  bucket = "${var.project_name}-storage-bucket"

  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
# ── GET LATEST AMAZON LINUX AMI ───────────────────────
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# ── EC2 INSTANCE ──────────────────────────────────────
resource "aws_instance" "main" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name      = "${var.project_name}-server"
    ManagedBy = "terraform"
  }
}
