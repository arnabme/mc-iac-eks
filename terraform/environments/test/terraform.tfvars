project_name        = "myorg"
environment         = "test"
aws_region          = "ap-south-1" # Mumbai

# VPC Configuration (could be different for test, or same if only logic changes)
vpc_cidr            = "10.1.0.0/16"
public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24"]

# EKS Cluster Configuration (e.g., larger instances, more nodes for test)
cluster_name        = "myorg-test-eks-cluster"
kubernetes_version  = "1.33"
instance_type       = "t3.large"
desired_size        = 2
max_size            = 3
min_size            = 2

aws_cli_user_name   = "your-aws-cli-user-name"