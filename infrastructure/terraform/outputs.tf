# Module outputs
output "ec2_private_ip" {
  description = "The private IP address of the newly created EC2 instance"
  value       = module.ec2.repository_url
}

output "ec2_instance_id" {
  description = "The ID of the newly created EC2 instance"
  value       = module.ec2.ec2_instance_id
}

output "ec2_instance_ami" {
  description = "The AMI of the newly created EC2 instance"
  value       = module.ec2.ec2_instance_amis
}

output "environment" {
  description = "The environment"
  value       = local.Env
}

output "project" {
  description = "The project name"
  value       = module.ec2.project
}