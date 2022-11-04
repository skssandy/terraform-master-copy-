module "app_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  create_vpc = var.create_vpc

  name                            = "${var.app_env}-${var.app_id}-vpc"
  cidr                            = var.vpc_cidr
  azs                             = data.aws_availability_zones.available.names
  private_subnets                 = var.vpc_private_subnets
  public_subnets                  = var.vpc_public_subnets
  enable_nat_gateway              = var.enable_nat_gateway
  single_nat_gateway              = "true"
  one_nat_gateway_per_az          = "false"
  enable_dns_hostnames            = "true"
  nat_eip_tags                    = local.nat_tags
  enable_ipv6                     = "true"
  assign_ipv6_address_on_creation = "true"
  public_subnet_ipv6_prefixes     = var.public_subnet_ipv6_prefixes
  private_subnet_ipv6_prefixes    = var.private_subnet_ipv6_prefixes
  
  tags = local.tags
}

data "aws_vpc" "vpc" {
  id = var.create_vpc ? module.app_vpc.vpc_id : var.vpc_id
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.vpc.id

  # this filter will work assuming the subnet names are named appropriately or terraform-aws-modules/vpc/aws is used
  # (currently works for all environments)
  filter {
    name   = "tag:Name"
    values = ["*-private-*"]
  }
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.vpc.id

  # this filter will work assuming the subnet names are named appropriately or terraform-aws-modules/vpc/aws is used
  # (currently works for all environments)
  filter {
    name   = "tag:Name"
    values = ["*-public-*"]
  }
}

locals {
  private_subnets = tolist(data.aws_subnet_ids.private_subnets.ids)
  public_subnets  = tolist(data.aws_subnet_ids.public_subnets.ids)
}

data "aws_availability_zones" "available" {
  state = "available"
}