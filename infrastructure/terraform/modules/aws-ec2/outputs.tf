# Module outputs
output "repository_url" {
  description = "AWS Private IP of the instance"
  value       = aws_instance.this.private_ip
}

output "ec2_instance_id" {
  description = "The ID of the newly created EC2 instance"
  value       = aws_instance.this.id
}

output "ec2_instance_amis" {
  description = "The AMI of the newly created EC2 instance"
  value       = aws_instance.this.ami
}

output "ec2_instance_private_ip" {
  description = "The private IP of the newly created EC2 instance"
  value       = aws_instance.this.private_ip
}

output "ec2_instance_public_ip" {
  description = "The public IP of the newly created EC2 instance"
  value       = aws_instance.this.public_ip
}

output "project" {
  description = "The project name"
  value       = local.project
}