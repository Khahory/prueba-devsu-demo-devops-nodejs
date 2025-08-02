# ===== MODULE OUTPUTS =====

# EKS Cluster outputs
output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.this.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = aws_eks_cluster.this.version
}

output "cluster_certificate_authority_data" {
  description = "The cluster certificate authority data"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# Node Group outputs
output "node_group_id" {
  description = "EKS node group ID"
  value       = aws_eks_node_group.this.id
}

output "node_group_arn" {
  description = "The Amazon Resource Name (ARN) of the node group"
  value       = aws_eks_node_group.this.arn
}

output "node_group_name" {
  description = "The name of the EKS node group"
  value       = aws_eks_node_group.this.node_group_name
}

output "node_group_status" {
  description = "The status of the EKS node group"
  value       = aws_eks_node_group.this.status
}

# IAM Role outputs
output "cluster_role_arn" {
  description = "The ARN of the EKS cluster IAM role"
  value       = aws_iam_role.eks_cluster.arn
}

output "node_group_role_arn" {
  description = "The ARN of the EKS node group IAM role"
  value       = aws_iam_role.eks_node_group.arn
}

# Security Group outputs
output "cluster_security_group_id" {
  description = "The ID of the EKS cluster security group"
  value       = aws_security_group.eks_cluster.id
}

output "node_group_security_group_id" {
  description = "The ID of the EKS node group security group"
  value       = aws_security_group.eks_node_group.id
}

# Project information
output "project" {
  description = "The project name"
  value       = local.project
}

output "environment" {
  description = "The environment name"
  value       = var.environment
} 