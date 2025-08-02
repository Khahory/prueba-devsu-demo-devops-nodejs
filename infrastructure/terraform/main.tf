# EC2
module "ec2" {
  source = "./modules/aws-ec2"

  tags        = local.tags
  environment = local.Env
}