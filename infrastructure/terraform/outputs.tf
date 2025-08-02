# Module outputs
# output "ec2_private_ip" {
#   description = "The private IP address of the newly created EC2 instance"
#   value       = module.ec2.repository_url
# }
#
# output "ec2_instance_id" {
#   description = "The ID of the newly created EC2 instance"
#   value       = module.ec2.ec2_instance_id
# }
#
# output "ec2_instance_ami" {
#   description = "The AMI of the newly created EC2 instance"
#   value       = module.ec2.ec2_instance_amis
# }
#
# output "environment" {
#   description = "The environment"
#   value       = local.Env
# }
#
# output "project" {
#   description = "The project name"
#   value       = module.ec2.project
# }

# ===== EKS OUTPUTS =====
output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = module.eks.cluster_version
}

output "eks_node_group_id" {
  description = "EKS node group ID"
  value       = module.eks.node_group_id
}

output "eks_node_group_name" {
  description = "The name of the EKS node group"
  value       = module.eks.node_group_name
}

output "eks_cluster_certificate_authority_data" {
  description = "The cluster certificate authority data"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}