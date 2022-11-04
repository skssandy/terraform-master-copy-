module "app_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  count = var.number_of_app_instance

  name = "${var.app_env}-${var.app_id}-app-${count.index + 1}"

  ami                    = var.app_ami
  instance_type          = var.app_server_instance_type
  key_name               = aws_key_pair.app_server_public_key.key_name
  monitoring             = true
  vpc_security_group_ids = var.enable_load_balancer ? [module.app_srvr_lb_sg.security_group_id] : [module.app_srvr_sg.security_group_id]
  subnet_id              = element((var.enable_nat_gateway ? local.private_subnets : local.public_subnets), count.index)
  iam_instance_profile   = resource.aws_iam_instance_profile.app_instance_profile.id

  tags = local.tags
}

resource "aws_eip" "app_eip" {
  count = var.enable_eip_app_instance ? var.number_of_app_instance : 0
  instance = module.app_ec2_instance[count.index].id
  vpc      = true

  tags = local.tags
}

module "bastion_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  create = var.create_bastion

  name = "${var.app_env}-${var.app_id}-bastion"
  ami                    = var.bastion_ami
  instance_type          = var.bastion_server_instance_type
  key_name               = aws_key_pair.bastion_public_key.key_name
  monitoring             = true
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  subnet_id              = element(local.public_subnets, 1)

  tags = local.tags
}

resource "aws_eip" "bastion_eip" {
  count = var.create_bastion ? 1 : 0

  instance = module.bastion_ec2_instance.id
  vpc      = true

  tags = local.tags
}