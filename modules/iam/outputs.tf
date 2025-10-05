output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "robinson_api_task_role_arn" {
  value = aws_iam_role.robinson_api_task_role.arn
}