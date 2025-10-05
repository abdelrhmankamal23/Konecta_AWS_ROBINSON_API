resource "aws_s3_bucket" "bucket_One" {
  bucket              = "cdk-hnb659fds-assets-777169761928-eu-west-1"
  bucket_prefix       = null
  force_destroy       = false
  object_lock_enabled = false
  region              = "eu-west-1"
  tags                = {}
  tags_all            = {}
}

resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket              = "stackset-stacksetcloudtrailwitchcloud-trailbucket-8ykv5u0zff7f"
  bucket_prefix       = null
  force_destroy       = false
  object_lock_enabled = false
  region              = "eu-west-1"
  tags = {
    Platform = "Cloudformation"
  }
  tags_all = {
    Platform = "Cloudformation"
  }
}