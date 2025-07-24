project_name        = "myorg"
environment         = "dev"
aws_region          = "ap-south-1" # Mumbai

# VPC Configuration
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

# EKS Cluster Configuration
cluster_name        = "myorg-dev-eks-cluster"
kubernetes_version  = "1.33"
instance_type       = "t3.medium"
desired_size        = 1
max_size            = 2
min_size            = 1

# AWS User for Cluster Access (replace with your actual IAM user name or adjust for role)
aws_cli_user_name   = "your-aws-cli-user-name" # Ensure this user is configured in your AWS CLI or GitHub Actions OIDC role