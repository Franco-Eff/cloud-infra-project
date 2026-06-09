# ── ZIP THE LAMBDA FUNCTIONS ─────────────────────────
# Terraform needs the Python files zipped before uploading to AWS

data "archive_file" "stop_ec2" {
  type        = "zip"
  source_file = "${path.module}/lambda/stop_ec2.py"
  output_path = "${path.module}/lambda/stop_ec2.zip"
}

data "archive_file" "start_ec2" {
  type        = "zip"
  source_file = "${path.module}/lambda/start_ec2.py"
  output_path = "${path.module}/lambda/start_ec2.zip"
}

# ── IAM ROLE FOR LAMBDA ───────────────────────────────
# Lambda needs permission to start/stop EC2 instances

resource "aws_iam_role" "lambda_ec2_scheduler" {
  name = "${var.project_name}-lambda-scheduler-role"

  # This trust policy allows Lambda to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-lambda-role"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

# ── IAM POLICY ────────────────────────────────────────
# Defines exactly what the Lambda role is allowed to do

resource "aws_iam_role_policy" "lambda_ec2_policy" {
  name = "${var.project_name}-lambda-ec2-policy"
  role = aws_iam_role.lambda_ec2_scheduler.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Allow Lambda to start and stop EC2 instances
        Effect = "Allow"
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      },
      {
        # Allow Lambda to write logs to CloudWatch
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# ── STOP LAMBDA FUNCTION ──────────────────────────────

resource "aws_lambda_function" "stop_ec2" {
  filename         = data.archive_file.stop_ec2.output_path
  function_name    = "${var.project_name}-stop-ec2"
  role             = aws_iam_role.lambda_ec2_scheduler.arn
  handler          = "stop_ec2.handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.stop_ec2.output_base64sha256

  # Pass the instance ID and region as environment variables
  environment {
    variables = {
      INSTANCE_ID = aws_instance.main.id
      EC2_REGION  = var.aws_region
    }
  }

  tags = {
    Name        = "${var.project_name}-stop-ec2"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

# ── START LAMBDA FUNCTION ─────────────────────────────

resource "aws_lambda_function" "start_ec2" {
  filename         = data.archive_file.start_ec2.output_path
  function_name    = "${var.project_name}-start-ec2"
  role             = aws_iam_role.lambda_ec2_scheduler.arn
  handler          = "start_ec2.handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.start_ec2.output_base64sha256

  environment {
    variables = {
      INSTANCE_ID = aws_instance.main.id
      EC2_REGION  = var.aws_region
    }
  }

  tags = {
    Name        = "${var.project_name}-start-ec2"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

# ── EVENTBRIDGE STOP SCHEDULE ─────────────────────────
# Triggers the stop function at 8PM UTC every day

resource "aws_cloudwatch_event_rule" "stop_ec2_schedule" {
  name                = "${var.project_name}-stop-ec2-schedule"
  description         = "Stops EC2 instance every day at 8PM UTC"
  schedule_expression = "cron(0 20 * * ? *)"

  tags = {
    Name        = "${var.project_name}-stop-schedule"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_event_target" "stop_ec2_target" {
  rule      = aws_cloudwatch_event_rule.stop_ec2_schedule.name
  target_id = "StopEC2"
  arn       = aws_lambda_function.stop_ec2.arn
}

resource "aws_lambda_permission" "allow_eventbridge_stop" {
  statement_id  = "AllowEventBridgeStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_ec2_schedule.arn
}

# ── EVENTBRIDGE START SCHEDULE ────────────────────────
# Triggers the start function at 8AM UTC every day

resource "aws_cloudwatch_event_rule" "start_ec2_schedule" {
  name                = "${var.project_name}-start-ec2-schedule"
  description         = "Starts EC2 instance every day at 8AM UTC"
  schedule_expression = "cron(0 8 * * ? *)"   #sets the schedule to be MON-FRI during business hours

  tags = {
    Name        = "${var.project_name}-start-schedule"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_event_target" "start_ec2_target" {
  rule      = aws_cloudwatch_event_rule.start_ec2_schedule.name
  target_id = "StartEC2"
  arn       = aws_lambda_function.start_ec2.arn
}

resource "aws_lambda_permission" "allow_eventbridge_start" {
  statement_id  = "AllowEventBridgeStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_ec2_schedule.arn
}
 
