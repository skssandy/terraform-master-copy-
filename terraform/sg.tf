module "app_srvr_lb_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create      = var.enable_load_balancer

  name        = "${var.app_env}-${var.app_id}-app-lg-sg"
  description = "Security group for ${var.app_env}-${var.app_id} app-lb-sg"
  vpc_id      = data.aws_vpc.vpc.id

  egress_with_ipv6_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "::/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  ingress_with_source_security_group_id =[
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      source_security_group_id = module.load_balancer_sg.security_group_id
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      source_security_group_id = module.load_balancer_sg.security_group_id
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      source_security_group_id = module.bastion_sg.security_group_id
    },
    {
      from_port   = 8081
      to_port     = 8081
      protocol    = "tcp"
      source_security_group_id = module.load_balancer_sg.security_group_id
    },
  ]

  tags = local.tags
}

module "bastion_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create      = var.create_bastion

  name        = "${var.app_env}-${var.app_id}-bastion-sg"
  description = "Security group for ${var.app_env}-${var.app_id}-bastion-sg"
  vpc_id      = data.aws_vpc.vpc.id

  egress_with_ipv6_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "::/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.cidc_vpn_cidr
    }
  ]

  tags = local.tags
}

module "app_srvr_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create = ! var.enable_load_balancer
  name        = "${var.app_env}-${var.app_id}-app-sg"
  description = "Security group for ${var.app_env}-${var.app_id} app-sg"
  vpc_id      = data.aws_vpc.vpc.id

  egress_with_ipv6_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "::/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.cidc_vpn_cidr
    },
    {
      from_port   = 8085
      to_port     = 8085
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  tags = local.tags
}

module "load_balancer_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create      = var.enable_load_balancer

  name        = "${var.app_env}-${var.app_id}-load-balancer"
  description = "Security group for ${var.app_env}-${var.app_id} load balancer"
  vpc_id      = module.app_vpc.vpc_id

  egress_with_ipv6_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "::/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"

    }
  ]

  tags = local.tags
}

module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws"
  name        = "${var.app_env}-${var.app_id}-rds-sg"
  description = "Security group for ${var.app_env}-${var.app_id}-rds-sg"
  vpc_id      = data.aws_vpc.vpc.id


  egress_with_ipv6_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "::/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  ingress_with_source_security_group_id = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      source_security_group_id = var.create_bastion ? module.app_srvr_lb_sg.security_group_id : module.app_srvr_sg.security_group_id
    }
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ] 
  tags = local.tags
}