variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.33" # Using Kubernetes 1.33
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the EKS worker nodes."
  type        = list(string)
}

variable "instance_type" {
  description = "The instance type for EKS worker nodes."
  type        = string
  default     = "t3.medium"
}

variable "desired_size" {
  description = "The desired number of EKS worker nodes."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of EKS worker nodes."
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum number of EKS worker nodes."
  type        = number
  default     = 1
}

variable "environment" {
  description = "The deployment environment (e.g., dev, test, prod)."
  type        = string
}

variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID where the resources are deployed."
  type        = string
}

variable "aws_cli_user_name" {
  description = "The AWS CLI user name for cluster access."
  type        = string
}