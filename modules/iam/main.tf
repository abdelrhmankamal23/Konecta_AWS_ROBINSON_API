resource "aws_iam_role" "lambda_password_policy_role" {
  name = "StackSet-StackSetPasswordPolicy-5e1837a-LambdaRole-1TCLUMCY77KXG"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "controltower_notification_role" {
  name = "aws-controltower-ForwardSnsNotificationRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "ebs_encryption_role" {
  name = "StackSet-StackSet-BackupV-EbsEncryptionByDefaultLa-2Z28MSOPYGG2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "delete_name_tags_role" {
  name = "AWS-QuickSetup-PatchPolicy-RoleForLambda-NT-eu-west-1-20ppj"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    QuickSetupID      = "20ppj"
    QuickSetupType    = "Patch Manager"
    QuickSetupVersion = "1.1"
  }
}