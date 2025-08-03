# ===== PROJECT CONFIGURATION =====
locals {
  project = "devsu-demo"
}

# ===== EKS CLUSTER CONFIGURATION =====
locals {
  cluster_name    = var.cluster_name != null ? var.cluster_name : "${local.project}-${var.environment}-eks"
  node_group_name = var.node_group_name != null ? var.node_group_name : "${local.project}-${var.environment}-node-group"

  eks_version = var.eks_version

  # VPC and Subnet configuration from variables
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Node group configuration from variables
  instance_type = var.instance_type
  desired_size  = var.desired_size
  max_size      = var.max_size
  min_size      = var.min_size
}

# ===== TAGS CONFIGURATION =====
locals {
  # Cluster tags
  tags_cluster = {
    Name = "${local.project}-${var.environment}-eks-cluster"
    Env  = var.environment
    Type = "eks-cluster"
  }

  # Node group tags
  tags_node_group = {
    Name = "${local.project}-${var.environment}-eks-node-group"
    Env  = var.environment
    Type = "eks-node-group"
  }
} 