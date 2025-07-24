
variable "project_name" {
  description = "The name of the project."
  type        = string
  default     = mc_iac_eks
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = test
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = ap-south-1
}


variable "vpc_cidr" {
  description = "VPC CIDR Network"
  type        = string
  default     = 10.1.0.0/16
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDR"
  type        = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDR"
  type        = list(string)
  default     = ["10.1.10.0/24", "10.1.11.0/24"]
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = mc-iac-eks-cluster
}

variable "kubernetes_version" {
  description = "Kubernetes Version"
  type        = string
  default     = 1.33
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = t3.large
}


variable "desired_size" {
  description = "Desired Size"
  type        = string
  default = 2
}

variable "max_size" {
  description = "Max Size"
  type        = string
  default = 3
}

variable "min_size" {
  description = "Min Size"
  type        = string
  default = 2
}

variable "aws_cli_user_name" {
  description = "AWS CLI User Name"
  type        = string
  default = AKIARGWBZATJJDOXV4FY
}

