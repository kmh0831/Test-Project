provider "aws" {
  region = "ap-northeast-2"
}

# CodeCommit repository
module "codecommit" {
  source = "./modules/codecommit.tf"
}

# CodeBuild project
module "codebuild" {
  source = "./modules/codebuild.tf"
}

# CodeDeploy application and deployment group
module "codedeploy" {
  source = "./modules/codedeploy.tf"
}

# CodePipeline
module "codepipeline" {
  source = "./modules/codepipeline.tf"
}

# EC2 Launch Template
module "ec2_template" {
  source = "./modules/ec2_template.tf"
}

# IAM roles and policies
module "iam" {
  source = "./modules/iam.tf"
}

# VPC
module "vpc" {
  source = "./modules/vpc.tf"
}

# ALB
module "alb" {
  source = "./modules/alb.tf"
}

# Autoscaling
module "autoscaling" {
  source = "./modules/autoscaling.tf"
}

# S3
module "s3" {
  source = "./modules/s3.tf"
}

# EC2
module "EC2" {
  source = "./modules/web-ec2.tf"
}