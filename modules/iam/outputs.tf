output "lambda_password_policy_role_arn" {
  value = aws_iam_role.lambda_password_policy_role.arn
}

output "controltower_notification_role_arn" {
  value = aws_iam_role.controltower_notification_role.arn
}

output "ebs_encryption_role_arn" {
  value = aws_iam_role.ebs_encryption_role.arn
}

output "delete_name_tags_role_arn" {
  value = aws_iam_role.delete_name_tags_role.arn
}