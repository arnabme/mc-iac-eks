
variable "project_name" {
  description = "The name of the project."
  type        = mc_iac_eks
}

variable "environment" {
  description = "Environment name"
  type        = dev
}

variable "aws_region" {
  description = "AWS Region"
  type        = ap-south-1
}


variable "vpc_cidr" {
  description = "VPC CIDR Network"
  type        = 10.5.0.0/16
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDR"
  type        = ["10.5.1.0/24", "10.5.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDR"
  type        = ["10.5.10.0/24", "10.5.11.0/24"]
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = mc-iac-eks-cluster
}

variable "kubernetes_version" {
  description = "Kubernetes Version"
  type        = 1.33
}

variable "instance_type" {
  description = "Instance Type"
  type        = t3.large
}


variable "desired_size" {
  description = "Desired Size"
  type        = 2
}

variable "max_size" {
  description = "Max Size"
  type        = 3
}

variable "min_size" {
  description = "Min Size"
  type        = 2
}

variable "aws_cli_user_name" {
  description = "AWS CLI User Name"
  type        = your-aws-cli-user-name
}

