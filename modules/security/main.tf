# Security Group for EC2 Instances
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-${var.environment}-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# Similar security groups for other resources (ALB, RDS, etc.)

# AWS WAF
resource "aws_waf_web_acl" "web_acl" {
  name        = "${var.project}-${var.environment}-web-acl"
  metric_name = "WebACL"

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = aws_waf_rule.sql_injection_rule.id
    type     = "REGULAR"
  }
}

resource "aws_waf_rule" "sql_injection_rule" {
  name        = "SQLInjectionRule"
  metric_name = "SQLInjectionRule"

  predicates {
    data_id = aws_waf_sql_injection_match_set.sql_injection_match_set.id
    negated = false
    type    = "SqlInjectionMatch"
  }
}

resource "aws_waf_sql_injection_match_set" "sql_injection_match_set" {
  name = "SQLInjectionMatchSet"

  sql_injection_match_tuples {
    text_transformation = "URL_DECODE"
    field_to_match {
      type = "QUERY_STRING"
    }
  }
}

# Additional security resources (AWS Shield Advanced, IAM roles, etc.)
