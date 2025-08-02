# General
locals {
  # Environment
  Env    = reverse(split("-", terraform.workspace))[0]
  Create = "Terraform"
  Owner  = "Developers"
}

# Tags
locals {
  tags = {
    Create = local.Create
    Owner  = local.Owner
  }
}
