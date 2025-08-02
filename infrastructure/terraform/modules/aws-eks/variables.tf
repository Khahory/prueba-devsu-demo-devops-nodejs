# ===== MODULE INPUTS =====
variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name (stage, production)"
  type        = string
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

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type for the node group"
  type        = string
  default     = null
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = null
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = null
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = null
}

variable "eks_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}