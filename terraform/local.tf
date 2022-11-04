# local variables
locals {
  account_id = data.aws_caller_identity.current.account_id

  tags = {
    "app:env"    = var.app_env
    "app:id"     = var.app_id
    "app:region" = var.aws_region
    "app:name"   = var.app_name
  }

  nat_tags = {
    "Name" = "${var.app_env}-${var.app_id}-nat"
  }
}