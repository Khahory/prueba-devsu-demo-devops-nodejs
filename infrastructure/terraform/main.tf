# EKS
module "eks" {
  source = "./modules/aws-eks"

  tags        = local.tags
  environment = local.Env
  eks_version = var.eks_version
  
  # VPC and Subnet configuration
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  
  # Cluster and Node Group names
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  
  # Node Group configuration
  instance_type = var.instance_type
  desired_size  = var.desired_size
  max_size      = var.max_size
  min_size      = var.min_size
}