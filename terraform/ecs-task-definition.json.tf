resource "aws_ecs_task_definition" "app" {
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
