# EKS Cluster Module
# Leverages the official terraform-aws-eks module

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0" # Using latest stable as of July 2025

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  cluster_endpoint_public_access = true # Set to false for production if needed
  cluster_endpoint_private_access = true

  # IAM Roles for Service Accounts (IRSA)
  enable_irsa = true

  # EKS Managed Node Groups
  managed_node_groups = {
    default = {
      instance_types = [var.instance_type]
      desired_size   = var.desired_size
      max_size       = var.max_size
      min_size       = var.min_size
      ami_type       = "AL2023_X86_64_STANDARD" # Recommended for EKS 1.33+
      disk_size      = 20
      tags = {
        Environment = var.environment
        Project     = var.project_name
      }
    }
  }

  # EKS Addons (CoreDNS, kube-proxy, VPC CNI are automatically handled by the module)
  # You can add more like ALB Ingress Controller, Cluster Autoscaler, etc. here
  cluster_addons = {
    coredns = {
      resolve_conflicts_on_create = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflicts_on_create = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts_on_create = "OVERWRITE"
    }
    # Example: Add ALB Ingress Controller (Requires OIDC enabled on cluster)
    # aws-load-balancer-controller = {
    #   service_account_name = "aws-load-balancer-controller"
    #   namespace            = "kube-system"
    # }
  }

  # EKS Access Entry for current user (for kubectl access)
  # In production, define specific IAM roles/users
  access_entry_enabled = true
  access_entries = {
    current_user_admin = {
      principal_arn       = "arn:aws:iam::${var.aws_account_id}:user/${var.aws_cli_user_name}" # Replace with your user/role ARN
      kubernetes_groups   = ["system:masters"]
      access_entry_type   = "STANDARD"
      # Policy associations can be added here
      # policy_associations = {
      #   admin = {
      #     policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      #     access_scope = {
      #       type = "cluster"
      #     }
      #   }
      # }
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}