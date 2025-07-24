output "cluster_id" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "The ARN of the E EKS cluster."
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster API."
  value       = module.eks.cluster_endpoint
}

output "kubeconfig" {
  description = "Kubecconfig for the EKS cluster (sensitive)."
  value = module.eks.kubeconfig
  sensitive = true
}

output "vpc_id" {
  description = "The VPC ID of the EKS cluster."
  value       = module.eks.vpc_id
}

output "private_subnet_ids" {
  description = "The private subnet IDs used by the EKS cluster."
  value       = module.eks.private_subnet_ids
}