resource "aws_ecr_repository" "robinson_api" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = false
}