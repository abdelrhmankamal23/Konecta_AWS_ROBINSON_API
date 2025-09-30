# Robinson API Infrastructure - Terraform Import Project

In production environments, AWS resources often exist before Terraform adoption. This project demonstrates how to import existing infrastructure into Terraform state, enabling Infrastructure as Code (IaC) management.

---

## Project Overview

**Robinson API Infrastructure Components:**
- **VPC**: `10.133.63.64/26` with 4 subnets across 2 availability zones
- **S3 Buckets**: CDK assets, CloudTrail logs, and deployment artifacts
- **Lambda Functions**: Password policy, notification forwarding, EBS encryption, and tag management
- **IAM Roles**: Service roles for Lambda functions
- **ECS Cluster**: Container orchestration for Robinson API
- **ECR Repository**: Docker image storage for application containers

---

## Prerequisites

### 1. AWS Access
Use provided AWS credentials (Access Key)

### 2. Install Required Tools
```bash
# AWS CLI v2
aws configure
# Access Key, Secret Key, eu-west-1, json

# Terraform
terraform -version

# Verify AWS access
aws sts get-caller-identity
```

### 3. Development Environment
- **VS Code** with HashiCorp Terraform extension
- **Git** for version control

---

## Project Structure

```
TaskOne/
├── main.tf                
├── provider.tf            
├── .terraform.lock.hcl    
└── modules/
    ├── vpc/               
    │   ├── main.tf        # VPC, subnets, and networking
    │   ├── variables.tf   
    │   └── outputs.tf     
    ├── s3/                
    │   ├── s3.tf          # Bucket definitions
    │   └── outputs.tf     
    ├── lambda/            
    │   ├── lambda.tf      # Function definitions
    │   ├── variables.tf   
    │   └── outputs.tf     
    ├── iam/               
    │   ├── main.tf        # Role definitions
    │   └── outputs.tf     
    ├── ecs/               
    │   ├── main.tf        # Cluster configuration
    │   ├── variables.tf   
    │   └── outputs.tf     
    └── ecr/               
        ├── main.tf        # Repository configuration
        ├── variables.tf   
        └── outputs.tf     
```
- Separation of Concerns: Each module handles one AWS service/componen
- Reusability: Modules can be used across different environments

---

## Resource Discovery and import Process

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Discover Existing Resources
```
# List resources
aws resourcegroupstaggingapi get-resources --region=eu-west-1 --output text

# VPC Module Resources
aws ec2 describe-vpcs
aws ec2 describe-subnets
aws ec2 describe-internet-gateways
aws ec2 describe-nat-gateways
aws ec2 describe-addresses
aws ec2 describe-route-tables
aws ec2 describe-network-acls
aws ec2 describe-security-groups

# S3 Module Resources
aws s3 ls

# Lambda Module Resources
aws lambda list-functions

# IAM Module Resources
aws iam list-roles

# ECS Module Resources
aws ecs list-clusters

# ECR Module Resources
aws ecr describe-repositories
```

### 3. Import Resources by Module

- Add resource to .tf fill
- Check required arguments from docs
- Fill them with values from live resource

#### VPC and Networking

```
terraform import module.vpc.aws_vpc.[local_resource_name] [vpc_id]
terraform import module.vpc.aws_subnet.[local_resource_name] [subnet_id]
```
---
#### S3 Buckets

```
terraform import module.s3.aws_s3_bucket.[local_resource_name] [bucket_name]
```
---
#### Lambda Functions

```
terraform import module.lambda.aws_lambda_function.[local_resource_name] [aws_function_name]
```

To get the description of the lambda function
```
aws lambda get-function --function-name [function-name]
```

To know which role the lambda function uses
```
aws lambda get-function --function-name [function-name] --query 'Configuration.Role'
```

Lambda function can get its code in two ways:  
- `Zip package`: we upload a .zip file that contains your code and dependencies where in terraform: package_type = "Zip"(default)
- `Container image`: you build a Docker image, push it to ECR, and Lambda pulls from there where in 
terraform: package_type = "Image"  

Here we have Lambda functions with `package_type = "Zip"`,so we need to provide dummy values for `s3_bucket` and `s3_key` in the file before importing as terraform requires code source arguments (filename, s3_bucket/s3_key, or image_uri). Then we prevent terraform to use them by `lifecycle.ignore_changes` that prevents terraform from using these placeholders, so we have to work around to solve this as before the import terraform validates schema  

We only have `RepositoryType` and `Location`:  
Because AWS Lambda stores function code internally and doesn't expose the exact S3 bucket/key details through the API. When you query a Lambda function, AWS only tells you these
RepositoryType: "S3" - means code is stored in S3  
Location: "https://..." - a pre-signed URL (expires in minutes)  

---
#### IAM Roles

```bash
terraform import module.iam.aws_iam_role.[local_resource_name] [role_name]
```
---
#### ECS and ECR

```bash
terraform import module.ecs.aws_ecs_cluster.[local_resource_name] [cluster_name]
terraform import module.ecr.aws_ecr_repository.[local_resource_name] [repository_name]
```
---
### 4. Validation
```bash
terraform plan
```
![result](./imgs/result.png)
---
---

## Configuration Highlights

### Lambda Functions with Lifecycle Management
```hcl
resource "aws_lambda_function" "password_policy" {
  function_name = "StackSet-StackSetPasswordPolicy-5-LambdaFunctionV2-0S9vD8e4SOH0"
  role          = "arn:aws:iam::777169761928:role/StackSet-StackSetPasswordPolicy-5e1837a-LambdaRole-1TCLUMCY77KXG"
  package_type  = "Zip"
  
  lifecycle {
    ignore_changes = [s3_bucket, s3_key, source_code_hash, handler, runtime]
  }
}
```

### Lifecycle Management is Required for Lambda Functions (Explanation)

When importing existing Lambda functions, we encounter a unique challenge:

**The Problem**
- AWS Lambda stores function code internally and doesn't expose exact S3 bucket/key details through APIs
- When querying Lambda functions, AWS only returns `RepositoryType: "S3"` and a temporary download URL
- Terraform requires `s3_bucket` and `s3_key` attributes for Zip package types, but we don't know the real values

**The Solution:**
```hcl
lifecycle {
  ignore_changes = [s3_bucket, s3_key, source_code_hash, handler, runtime]
}
```
Why lifecycle ignore_changes:
When you import a Lambda function, Terraform needs to know where the code comes from (s3_bucket and s3_key). But since AWS doesn't tell us the real values, we use dummy placeholders.  
Without ignore_changes, Terraform would try to "fix" the Lambda function by uploading our dummy code, overwriting the real function code.  
With ignore_changes, Terraform says: "I'll manage this Lambda function's configuration (name, role, etc.) but I won't touch the code deployment part."  
Simple analogy: It's like managing a house but ignoring what furniture is inside - you control the address and ownership, but don't mess with the contents.

This approach allows us to import and manage existing Lambda functions without disrupting their operational code.

---

## Workflow Summary

1. **Initialize**: `terraform init`
2. **Discover**: Use AWS CLI to identify resources
3. **Import**: Use `terraform import` for each resource
4. **Validate**: Run `terraform plan` to confirm no changes
5. **Maintain**: Regular validation and updates

---

## Conclusion

This project successfully demonstrates importing existing AWS infrastructure into Terraform state management. The Robinson API infrastructure is now fully managed as code, enabling version control, collaboration, and automated deployment processes.
