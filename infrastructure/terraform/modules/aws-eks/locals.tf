# ===== PROJECT CONFIGURATION =====
locals {
  project = "devsu-demo"
}

# ===== EKS CLUSTER CONFIGURATION =====
locals {
  cluster_name    = var.cluster_name != null ? var.cluster_name : "${local.project}-${var.environment}-eks"
  node_group_name = var.node_group_name != null ? var.node_group_name : "${local.project}-${var.environment}-node-group"

  eks_version = var.eks_version

  # VPC and Subnet configuration based on environment
  vpc_id = var.vpc_id != null ? var.vpc_id : (
    var.environment == "stage"
    ? "vpc-08d0bf1a6fd73939b" # vpc:network-stage
    : "vpc-08d0bf1a6fd73939b" # vpc:network-production
  )

  subnet_ids = var.subnet_ids != null ? var.subnet_ids : (
    var.environment == "stage"
    ? ["subnet-03ccebed1bcc736d0", "subnet-0e636cdba3c2dbce2"] # public subnets for stage
    : ["subnet-03ccebed1bcc736d0", "subnet-0e636cdba3c2dbce2"] # public subnets for production
  )

  # Node group configuration
  instance_type = var.environment == "stage" ? "t4g.medium" : "t4g.medium"

  desired_size = var.desired_size != null ? var.desired_size : 1
  max_size     = var.max_size != null ? var.max_size : 2
  min_size     = var.min_size != null ? var.min_size : 1
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