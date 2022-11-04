resource "aws_db_instance" "mysql" {
  allocated_storage           = var.db_allocated_storage
  max_allocated_storage       = var.db_maximum_storage
  engine                      = var.db_engine
  identifier                  = "${var.app_env}-${var.app_id}-db" 
  engine_version              = var.db_version
  instance_class              = var.db_instance_class
  name                        = var.db_name
  username                    = var.db_user_name
  password                    = var.db_password
  backup_retention_period     = var.backup_retention_period
  skip_final_snapshot         = true
  publicly_accessible         = true        ## based on bastion
  port                        = var.db_port
  allow_major_version_upgrade = true
  vpc_security_group_ids      = [module.rds_sg.security_group_id]
  db_subnet_group_name        = aws_db_subnet_group.db_sub_group.name
  tags                        = local.tags
}
resource "aws_db_subnet_group" "db_sub_group" {
  name       = "${var.app_env}-${var.app_id}-db-subnet-grp"
  subnet_ids = var.enable_nat_gateway ? [module.app_vpc.private_subnets[0], module.app_vpc.private_subnets[1]] : [module.app_vpc.public_subnets[0], module.app_vpc.public_subnets[1]]
  tags       = local.tags 
}