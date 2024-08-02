provider "aws" {
  region = "ap-northeast-2"
}

# CodeCommit repository
module "codecommit" {
  source = "./modules/codecommit"
}

# CodeBuild project
module "codebuild" {
  source = "./modules/codebuild"
}

# CodeDeploy application and deployment group
module "codedeploy" {
  source = "./modules/codedeploy"
}

# CodePipeline
module "codepipeline" {
  source = "./modules/codepipeline"
}

# EC2 Launch Template
module "ec2_template" {
  source = "./modules/ec2_template"
}

# IAM roles and policies
module "iam" {
  source = "./modules/iam"
}

# VPC
module "vpc" {
  source = "./modules/vpc"
}

# ALB
module "alb" {
  source = "./modules/alb"
}

# Autoscaling
module "autoscaling" {
  source = "./modules/autoscaling"
}

# S3
module "s3" {
  source = "./modules/s3"
}

# EC2
module "EC2" {
  source = "./modules/web-ec2"
}