# CloudWatch Logs Group
resource "aws_cloudwatch_log_group" "app_logs" {
  name = "/aws/${var.project}/${var.environment}/app"

  retention_in_days = 30

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project}-${var.environment}-HighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  alarm_description = "This metric monitors EC2 CPU utilization"

  dimensions = {
    AutoScalingGroupName = module.ec2.ec2_asg_name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# SNS Topic for Alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.project}-${var.environment}-alerts"

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# Subscribe email or other endpoints to SNS topic as needed
