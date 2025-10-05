resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_service" "robinson_api_service" {
  name            = "service-robinson-api"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = "RobinsonApiCdkStackTaskDef1FB649D8:3"
  deployment_minimum_healthy_percent = 50
  health_check_grace_period_seconds = 60
  desired_count   = 1

  load_balancer {
    container_name   = "RobinsonContainer"
    container_port   = 80
    target_group_arn = "arn:aws:elasticloadbalancing:eu-west-1:777169761928:targetgroup/Robins-servi-KSHCOYQ0W5NS/eb9a94689ddbea3d"
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = ["sg-0ed4f115bd2224a0f"]
    subnets          = [
      "subnet-0156021c19e67844d",
      "subnet-0c391907aa30b3c96"
    ]
  }
}