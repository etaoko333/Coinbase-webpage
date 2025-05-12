resource "aws_ecs_cluster" "main" {
  name = "react-app-cluster"
}

resource "aws_ecs_task_definition" "project" {
  family                   = "react-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "react-app",
      image     = "851725512876.dkr.ecr.us-west-1.amazonaws.com/coinbase-app:latest",
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "react-app-service"
  cluster         = aws_ecs_cluster.main.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1

  network_configuration {
    subnets         = module.vpc.public_subnets
    assign_public_ip = true
    security_groups = [aws_security_group.alb_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "react-app"
    container_port   = 80
  }
  depends_on = [aws_lb_listener.http]
}