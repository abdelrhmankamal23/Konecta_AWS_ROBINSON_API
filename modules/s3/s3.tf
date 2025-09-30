resource "aws_s3_bucket" "bucket_One" {
  bucket = "cdk-hnb659fds-assets-777169761928-eu-west-1"
}

resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "stackset-stacksetcloudtrailwitchcloud-trailbucket-8ykv5u0zff7f"
  tags = {
    Platform = "Cloudformation"
  }
}