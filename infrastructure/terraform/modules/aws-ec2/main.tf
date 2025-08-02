# Create a new EC2 instance
// var it's a variable that can be used in the module

resource "aws_instance" "this" {
  ami                         = local.ami
  instance_type               = local.instance_type
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = local.key_name
  associate_public_ip_address = false
  root_block_device {
    volume_type = "gp3"
    volume_size = 10
    tags        = merge(var.tags, local.tags_ec2)
  }

  tags = merge(var.tags, local.tags_ec2)
}

# Create a new security group
resource "aws_security_group" "this" {
  name        = local.tags_sg.Name
  description = "Allow traffic from internal network"
  tags        = merge(var.tags, local.tags_sg)
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
