module "vpc" {
  source = "./modules/vpc"
  
  cidr_block           = "10.133.63.64/26"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Country  = "Espana"
    Name     = "10.133.63.64/26-VPC-Robinson API"
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

module "lambda" {
  source = "./modules/lambda"
}
