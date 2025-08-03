# ===== ROOT VARIABLES =====
# Variables for the main terraform configuration

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = null
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type for the node group"
  type        = string
  default     = "t4g.medium"
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "eks_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.33"
} 