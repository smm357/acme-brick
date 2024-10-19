# ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "acme-bricks-docker-image"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

# ECS Service
resource "aws_ecs_service" "service" {
  name            = "${var.project}-${var.environment}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }

  depends_on = [aws_ecs_cluster.cluster]
}

# Security Group for ECS
resource "aws_security_group" "ecs_sg" {
  name        = "${var.project}-${var.environment}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

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
