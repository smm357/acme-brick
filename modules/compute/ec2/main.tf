# Launch Template
resource "aws_launch_template" "ec2_lt" {
  name_prefix   = "${var.project}-${var.environment}-ec2-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.medium"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  security_group_names = [aws_security_group.ec2_sg.name]

  user_data = filebase64("${path.module}/user_data.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      "Environment" = var.environment
      "Project"     = var.project
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  name                      = "${var.project}-${var.environment}-ec2-asg"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  vpc_zone_identifier       = var.private_subnets
  launch_template {
    id      = aws_launch_template.ec2_lt.id
    version = "$Latest"
  }

  tag {
      key                 = "Environment"
      value               = var.environment
      propagate_at_launch = true
    }
  
  tag {
      key                 = "Project"
      value               = var.project
      propagate_at_launch = true
    }
}

# Data source to get latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# IAM Role and Instance Profile
resource "aws_iam_role" "ec2_role" {
  name = "${var.project}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Attach policies to the role as needed

# Add user data script (user_data.sh)

