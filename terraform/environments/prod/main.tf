# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Source the shared backend configuration
terraform {
  backend "s3" {} # Referenced in terraform/shared/backend.tf
}

data "aws_caller_identity" "current" {}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name        = var.cluster_name
}

# EKS Cluster Module
module "eks_cluster" {
  source = "../../modules/eks-cluster"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  instance_type      = var.instance_type
  desired_size       = var.desired_size
  max_size           = var.max_size
  min_size           = var.min_size
  environment        = var.environment
  project_name       = var.project_name
  aws_account_id     = data.aws_caller_identity.current.account_id
  aws_cli_user_name  = var.aws_cli_user_name
}

output "eks_cluster_endpoint" {
  value       = module.eks_cluster.cluster_endpoint
  description = "The endpoint of the EKS cluster."
}

output "eks_cluster_name" {
  value       = module.eks_cluster.cluster_id
  description = "The name of the EKS cluster."
}