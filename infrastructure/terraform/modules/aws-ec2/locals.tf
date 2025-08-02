locals {
  project = "devsu-demo"
}

locals {
  ami = (
    var.environment == "stage"
    ? "ami-0aaf509a1ebd95e61" # Amazon Linux 2023 Architecture: arm64
    : "ami-0aaf509a1ebd95e61" # Amazon Linux 2023 Architecture: arm64
  )

  instance_type = (
    var.environment == "stage"
    ? "t4g.micro"
    : "t4g.small"
  )

  key_name = (
    var.environment == "stage"
    ? "devsu-demo-angel"
    : "devsu-demo-angel"
  )

  subnet_id = (
    var.environment == "stage"
    ? "subnet-03ccebed1bcc736d0" # public subnet
    : "subnet-0e636cdba3c2dbce2" # public subnet
  )

  vpc_id = (
    var.environment == "stage"
    ? "vpc-08d0bf1a6fd73939b" # vpc:networck-stage
    : "vpc-08d0bf1a6fd73939b" # vpc:networck-production
  )
}

locals {
  // tags ec2
  tags_ec2 = {
    Name = "${local.project}-${var.environment}-ec2"
    Env  = var.environment
  }

  // tags security group
  tags_sg = {
    Name = "${local.project}-${var.environment}-sg"
    Env  = var.environment
  }
}
