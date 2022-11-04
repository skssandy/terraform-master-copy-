######################################################
#----              Common variables              ----#
######################################################
variable "app_env" {
}

variable "aws_cli_profile" {
  type        = string
  description = "AWS_CLI named profile"
}

variable "aws_region" {
}

variable "app_name" {
  type        = string
  description = "Application name"
  default     = "test"
}

variable "app_id" {
  type        = string
  description = "Application short name"
  default     = "test"
}

######################################################
#----VPC,Subnets,Gateways configuration variables----#
######################################################

variable "create_vpc" {
  type        = bool
  description = "Create a new VPC?"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "NAT gateway required?"
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC id"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "A list of private subnets inside the VPC"
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "A list of public subnets inside the VPC"
}

variable "public_subnet_ipv6_prefixes" {
  type        = list(string)
  description = "prefix to ipv6"
}
variable "private_subnet_ipv6_prefixes" {
  type        = list(string)
  description = "prefix to ipv6"
}

######################################################
#------------------------EC2-------------------------#
######################################################

variable "app_ami" {
  type        = string
  description = "The AMI value for EC2 creation"
}

variable "bastion_ami" {
  type        = string
  description = "The AMI value for bastion EC2 creation"
}

variable "app_server_instance_type" {
  type        = string
  description = "The Instance type"
}

variable "bastion_server_instance_type" {
  type        = string
  description = "The Instance type"
  default     = "t2.micro"
}

variable "number_of_app_instance" {
  type        = number
  description = "Number of app servers"
}

variable "create_bastion" {
  type        = bool
  description = "Create bastion server"
}
variable "enable_eip_app_instance" {
  type        = bool
  description = "Attach elastic ip for appliaction servers?"
}

variable "enable_load_balancer" {
  type        = bool
  description = "Enable load balancer if needed"
}

######################################################
#------------------Security Group--------------------#
######################################################

variable "cidc_vpn_cidr" {
  type        = string
  description = "A list of cidr block i.e. ConcertIDC VPN"
  default     = "0.0.0.0/0"
}

######################################################
#-----------------------RDS--------------------------#
######################################################

variable "db_engine"{
  type        = string
  description = "database engine name"
}
variable "db_instance_class"{
  type        = string
  description = "database instance class"
}
variable "db_version"{
  type        = string
  description = "database engine version"
}
variable "db_allocated_storage"{
  type        = number
  description = "database allocated storage"
} 
variable "db_maximum_storage"{
  type        = number
  description = "database maximum storage"
} 
variable "db_engine_version"{
  type        = string
  description = "database engine version"
} 
variable "db_user_name"{ 
  type        = string
  description = "username for databse"
} 
variable "db_password"{ 
  type        = string
  description = "password for database"
} 
variable "db_name"{
  type        = string
  description = "database name"
} 
variable "db_port"{
  type        = number
  description = "database port number"
}
variable "backup_retention_period" {
  type        = number
  description = "backup retention period value"
}
