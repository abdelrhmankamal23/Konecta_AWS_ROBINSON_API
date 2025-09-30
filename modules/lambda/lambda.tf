resource "aws_lambda_function" "password_policy" {
  function_name = "StackSet-StackSetPasswordPolicy-5-LambdaFunctionV2-0S9vD8e4SOH0"
  role          = "arn:aws:iam::777169761928:role/StackSet-StackSetPasswordPolicy-5e1837a-LambdaRole-1TCLUMCY77KXG"
  package_type  = "Zip"
  s3_bucket     = "aws-lambda-code"
  s3_key        = "function.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
  timeout       = 60
  publish       = false
  
  lifecycle {
    ignore_changes = [s3_bucket, s3_key, source_code_hash, handler, runtime, timeout, publish]
  }
}

resource "aws_lambda_function" "notification_forwarder" {
  function_name = "aws-controltower-NotificationForwarder"
  role          = "arn:aws:iam::777169761928:role/aws-controltower-ForwardSnsNotificationRole"
  package_type  = "Zip"
  s3_bucket     = "aws-lambda-code"
  s3_key        = "function.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
  timeout       = 60
  publish       = false
  description   = "SNS message forwarding function for aggregating account notifications."
  
  environment {
    variables = {
      sns_arn = "arn:aws:sns:eu-west-1:603321434203:aws-controltower-AggregateSecurityNotifications"
    }
  }
  
  lifecycle {
    ignore_changes = [s3_bucket, s3_key, source_code_hash, handler, runtime]
  }
}

resource "aws_lambda_function" "ebs_encryption" {
  function_name = "StackSet-StackSet-BackupV-EbsEncryptionByDefaultLa-k8GHyuVcJf6A"
  role          = "arn:aws:iam::777169761928:role/StackSet-StackSet-BackupV-EbsEncryptionByDefaultLa-2Z28MSOPYGG2"
  package_type  = "Zip"
  s3_bucket     = "aws-lambda-code"
  s3_key        = "function.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
  timeout       = 20
  publish       = false
  
  lifecycle {
    ignore_changes = [s3_bucket, s3_key, source_code_hash, handler, runtime, timeout, publish]
  }
}

resource "aws_lambda_function" "delete_name_tags" {
  function_name = "delete-name-tags-eu-west-1-20ppj"
  role          = "arn:aws:iam::777169761928:role/AWS-QuickSetup-PatchPolicy-RoleForLambda-NT-eu-west-1-20ppj"
  package_type  = "Zip"
  s3_bucket     = "aws-lambda-code"
  s3_key        = "function.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
  timeout       = 900
  publish       = false
  description   = "Lambda for handling CF 'Delete' events to remove the name tags from resources."
  
  environment {
    variables = {
      REGION = "eu-west-1"
    }
  }
  
  tags = {
    QuickSetupID      = "20ppj"
    QuickSetupType    = "Patch Manager"
    QuickSetupVersion = "1.1"
  }
  
  lifecycle {
    ignore_changes = [s3_bucket, s3_key, source_code_hash, handler, runtime]
  }
}