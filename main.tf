locals {
  common_tags = {
    Country  = "Espana"
    Platform = "Terraform"
    Project  = "Robinson API"
  }
}

module "s3" {
  source = "./modules/s3"
}

module "ecs" {
  source = "./modules/ecs"
  cluster_name = "robinson-api"
}

module "ecr" {
  source = "./modules/ecr"
  
  repository_name      = "robinson-api"
  image_tag_mutability = "MUTABLE"
}

module "iam" {
  source = "./modules/iam"
}

module "lb" {
  source = "./modules/lb"
}

