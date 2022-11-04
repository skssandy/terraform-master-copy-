variable "region" {
  type    = string
  default = "us-east-2"
}
variable "aws_profile" {
  type    = string
  default = "default"
}
variable "environment" {
  type    = string
  default = "stage"
}
variable "source_ami" {
  type    = string
  default = "ami-0d5bf08bc8017c83b"
}
variable "instance_type" {
  type    = string
  default = "t3.small"
}