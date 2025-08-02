# EC2 - only for reference, not used in this example
# module "ec2" {
#   source = "./modules/aws-ec2"
#
#   tags        = local.tags
#   environment = local.Env
# }

# EKS
module "eks" {
  source = "./modules/aws-eks"

  tags        = local.tags
  environment = local.Env
  eks_version = "1.33"
}