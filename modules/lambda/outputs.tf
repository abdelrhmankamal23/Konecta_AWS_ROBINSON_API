output "password_policy_name" {
  value = aws_lambda_function.password_policy.function_name
}

output "notification_forwarder_name" {
  value = aws_lambda_function.notification_forwarder.function_name
}

output "ebs_encryption_name" {
  value = aws_lambda_function.ebs_encryption.function_name
}

output "delete_name_tags_name" {
  value = aws_lambda_function.delete_name_tags.function_name
}