module "load_balancer" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 6.0"
  name               = "${var.app_env}-${var.app_id}-load-balancer"
  load_balancer_type = "application"
  vpc_id             = module.app_vpc.vpc_id
  subnets            = module.app_vpc.public_subnets
  security_groups    = [module.load_balancer_sg.security_group_id]

  count = var.enable_load_balancer ? var.number_of_app_instance : 0

  target_groups = [
    {
      name_prefix      = "prod"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = module.app_ec2_instance[count.index].id
          port      = 80
        }
      ]
    }
  ]
http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect    = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
  ]

  tags = local.tags
}