# ===== EKS CLUSTER =====
resource "aws_eks_cluster" "this" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = local.eks_version

  vpc_config {
    subnet_ids              = local.subnet_ids
    endpoint_public_access  = true
    endpoint_private_access = false
    security_group_ids      = [aws_security_group.eks_cluster.id]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
  ]

  tags = merge(var.tags, local.tags_cluster)
}

# ===== EKS NODE GROUP =====
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = local.node_group_name
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = local.subnet_ids
  version         = local.eks_version

  capacity_type  = "ON_DEMAND"
  instance_types = [local.instance_type]
  ami_type       = "AL2023_ARM_64_STANDARD"

  scaling_config {
    desired_size = local.desired_size
    max_size     = local.max_size
    min_size     = local.min_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    env = var.environment
  }

  tags = merge(var.tags, local.tags_node_group)

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
  ]
}

# ===== IAM ROLES =====
# EKS Cluster Role
resource "aws_iam_role" "eks_cluster" {
  name = "${local.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, local.tags_cluster)
}

# EKS Node Group Role
resource "aws_iam_role" "eks_node_group" {
  name = "${local.cluster_name}-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, local.tags_node_group)
}

# ===== IAM ROLE POLICY ATTACHMENTS =====
# Cluster policies
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}

# Node group policies
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
}

# ===== SECURITY GROUPS =====
# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name_prefix = "${local.cluster_name}-cluster-"
  description = "EKS cluster security group"
  vpc_id      = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, local.tags_cluster)
}

# EKS Node Group Security Group
resource "aws_security_group" "eks_node_group" {
  name_prefix = "${local.cluster_name}-node-group-"
  description = "EKS node group security group"
  vpc_id      = local.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, local.tags_node_group)
}

# ===== EKS ADD-ONS =====
# VPC CNI Add-on
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = "vpc-cni"
  addon_version = "v1.20.0-eksbuild.1"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_node_group.this]
}

# CoreDNS Add-on
resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = "coredns"
  addon_version = "v1.12.2-eksbuild.4"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_node_group.this]
}

# kube-proxy Add-on
resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = "kube-proxy"
  addon_version = "v1.33.0-eksbuild.2"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_node_group.this]
} 