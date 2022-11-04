# module "s3-bucket" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "2.14.1"

#   bucket  = "${var.app_env}-${var.app_name}"
#   acl     = "private"
 
# }