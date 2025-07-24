project_name        = "myorg"
environment         = "prod"
aws_region          = "ap-south-1" # Mumbai

# VPC Configuration (often isolated in production, potentially different account)
vpc_cidr            = "10.2.0.0/16"
public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.10.0/24", "10.2.11.0/24"]

# EKS Cluster Configuration (e.g., larger, more resilient instances for prod)
cluster_name        = "myorg-prod-eks-cluster"
kubernetes_version  = "1.33"
instance_type       = "m5.large" # Production-grade instance type
desired_size        = 3
max_size            = 5
min_size            = 3

aws_cli_user_name   = "your-aws-cli-user-name" # A dedicated production IAM user/role is best practice